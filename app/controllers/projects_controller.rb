class ProjectsController < ApplicationController
	def new
		if can? :create , Project
			@project = Project.new
			@dev = User.where(user_type: "developer")
			@qa = User.where(user_type: "qa")
		else
			flash[:danger] = "Only manager can create project"
			redirect_to root_path
		end
		# if manager?
		# 	@users1 = User.where(user_type: "developer")
		# 	@users2 = User.where(user_type: "qa")
		# 	@project = Project.new
		# else
		# 	flash[:danger] = "Only manager can create project"
		# 	redirect_to root_path
		# end
	end

	def create
		if can? :create, Project
			# debugger
			@project = Project.new(project_params)
			@project.user_id = current_user.id

			if @project.save
				redirect_to project_path(@project)
			else
				flash[:danger] = "Failed"
				redirect_to new_project_path
			end
		else
			flash[:danger] = "Only manager can create project"
			redirect_to root_path
		end
		
	end

	def show
		@project = Project.find(params[:id])
		if !can_update_bug(@project.id)
			flash[:danger] = "Access Denied"
			redirect_to projects_path
		end
	end

	def edit
		@project = Project.find(params[:id])
		unless can? :update, @project
			flash[:danger] = "Only manager and creater can edit project"
			redirect_to root_path
		end
		
	end

	def update

		if can? :update, Project
			@project = Project.find(params[:id])
			if @project.update(project_params)
				redirect_to project_path(@project)
			else
				flash[:danger] = "Something went wrong! Try again later!"
				render 'edit'
			end
		else
			flash[:danger] = "Only manager and creater can update projects"
			redirect_to projects_path
		end

	end

	def destroy
		@project = Project.find(params[:id])
		if can? :destroy, Project
			if Project.find(params[:id]).destroy
				flash[:success] = "Deleted Sucessfully"
				redirect_to projects_path
			else
				flash[:danger] = "Something went Wrong. Try Later!"
			end
		else
			flash[:danger] = "Only manager can delete project"
			redirect_to projects_path
		end
	end

	def index
		if current_user.user_type == 'manager'
			@projects = Project.where(user_id: current_user.id)
		else
			@projects = current_user.projects
		end
	end

	private

		def project_params
			params.require(:project).permit(:name,:description,user_ids: [])
		end

end