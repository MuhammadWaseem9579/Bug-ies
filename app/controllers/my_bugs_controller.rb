class MyBugsController < ApplicationController

	def index
		flash[:danger] = "Bugs have no existance without project"
		redirect_to projects_path
		# if can? :read, MyBug
		# 	if manager? || qa?
		# 		@bugs = MyBug.where(user_id: current_user.id)
		# 	else
		# 		# @bugs = current_user.my_bugs
		# 		@bugs = MyBug.where(assigned_to: current_user.id )
		# 	end
		# else

		# 		flash[:danger] = "Please login to use our app"
		# 		redirect_to request.referer
		# end
	end

	def new
		if can? :create, MyBug
			@project_id = params[:project_id]
			if @project_id.present?
				if can_create_bug(params[:project_id])
					@bug = MyBug.new
				else
					flash[:danger] = "Access Denied..."
					redirect_to root_path
				end
			else
				flash[:danger] = "Can't create bug without a project"
				redirect_to projects_path
			end
		else
			flash[:danger] = "Only Manager or Qa can create bug"
			redirect_to root_path
		end
	end

	def create
		if can? :create, MyBug
			@bug = MyBug.new(bug_params)
			# @bug.bug_type = params[:my_bug][:bug_type]

			if @bug.save
				redirect_to project_path(@bug.project_id)
			else
				flash[:danger] = "Request failed.."
				render 'new'
			end
		else
			flash[:danger] = "Only Manager or Qa can create bug"
		end
	end

	def show
		if can? :read, MyBug
			@bug = MyBug.find(params[:id])
			if !can_update_bug(@bug.project_id)
				flash[:dnager] = "Access Denied..."
				redirect_to root_path
			end
		else
			flash[:danger] = "Access Denied..."
			redirect_to request.referer
		end
	end

	def edit
		if !can_update_bug(@bug.project.id)
			@bug = MyBug.find(params[:id])
			flash[:danger] = "Only Project Related Person can Make changes"
			redirect_to root_path
		end
	end

	def update
		@bug = MyBug.find(params[:id])
		if @bug.update(bug_params)
			flash[:success] = "Updated Sucessfully"
		else
			flash[:danger] = "Update failed.. try again later.."
		end
		redirect_to my_bug_path(@bug)
	end

	def bug_status
		@bug = MyBug.find(params[:id])
		@bug.update(status: params[:status])
		render json: {success: "ok"}
	end

	def destroy
		if can_update_bug(@bug.project.id)
			if can? :destroy, MyBug
				@bug = MyBug.find(params[:id])
				if @bug.destroy
					flash[:success] = "Deleted Sucessfully..."
					redirect_to my_bugs_path
				else
					flash[:danger] = "Something went wrong..."
					render 'my_bug'
				end
			else
				flash[:danger] = "Only Creater of bug can delete his bug..."
				render 'my_bug'
			end
		end
	end

	private

	def bug_params
		params.require(:my_bug).permit(:title,:description,:assigned_to,:status,:bug_type,:project_id,:user_id,:status,:deadline,:image)
	end

end