class MyBugsController < ApplicationController

	def index
		if user_signed_in?

			if manager? || qa?
				@bugs = MyBug.where(user_id: current_user.id)
			else
				# @bugs = current_user.my_bugs
				@bugs = MyBug.where(assigned_to: current_user.id )
			end

		else

			flash[:danger] = "Please Login First..."
			redirect_to root_path

		end
	end

	def new
		if can_create_bug?
			@project_id = params[:project_id]
			if @project_id.present?
				@bug = MyBug.new
			else
				redirect_to projects_path
			end
		else
			flash[:danger] = "Only Manager or Qa can create bug"
		end
	end

	def create
		if can_create_bug?
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
		@bug = MyBug.find(params[:id])
	end

	def edit
		@bug = MyBug.find(params[:id])
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

	def destroy
		@bug = MyBug.find(params[:id])
		if @bug && @bug.user == current_user
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

	private

		def bug_params
			params.require(:my_bug).permit(:title,:description,:assigned_to,:status,:bug_type,:project_id,:user_id,:status,:deadline)
		end

end