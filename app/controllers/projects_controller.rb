class ProjectsController < ApplicationController
	def new
		if manager?
			@users1 = User.where(user_type: "developer")
			@users2 = User.where(user_type: "qa")
			@project = Project.new
		else
			flash[:danger] = "Only manager can create project"
			redirect_to root_path
		end
	end

	def create
		if manager?
			@project = Project.new(project_params)
			@project.user_id = current_user.id
			@project.user_ids = params[:users1].map(&:to_i) + params[:users2].map(&:to_i)
			if @project.save
				redirect_to project_path(@project)
			else
				flash[:danger] = "Failed"
				render 'new'
			end
		else
			flash[:danger] = "Only manager can create project"
			redirect_to root_path
		end
		
	end

	def show
		@project = Project.find(params[:id])
	end

	def edit
		if manager?
			@project = Project.find(params[:id])
		else
			flash[:danger] = "Only manager can eidt project"
			redirect_to root_path
		end
		
	end

	def update

		if manager?
			@project = Project.find(params[:id])
			if @project.update(project_params)
				redirect_to project_path(@project)
			else
				flash[:danger] = "Something went wrong! Try again later!"
				render 'edit'
			end
		else
			flash[:danger] = "Only manager can update projects"
			redirect_to projects_path
		end

	end

	def destroy
		@project = Project.find(params[:id])
		if manager?
			if Project.find(params[:id]).destroy
				flash[:success] = "Deleted Sucessfully"
			else
				flash[:danger] = "Something went Wrong. Try Later!"
			end
		else
			flash[:danger] = "Only manager can delete project"
			redirect_to project_path(@project)
		end
	end

	def index
		@projects = Project.all
	end

	private

		def project_params
			params.require(:project).permit(:name,:description,user_ids: [])
		end
		
end