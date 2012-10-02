class ProjectUsersController < ApplicationController
  respond_to :html, :xml, :json

  before_filter :load_project

  # GET /projects/1/stages/new
  def new
    @project_access = current_project.project_accesses.new
    respond_with(@project_access)
  end

  # POST /projects/1/stages
  # POST /projects/1/stages.xml
  def create
    @project_access = current_project.project_accesses.where(
      params[:project_access].merge(:project_id => current_project.id)
    ).first_or_create

    if @project_access
      add_activity_for(@project_access, 'created')
      flash[:notice] = 'User was successfully added to project.'
      respond_with(current_project, :location => current_project)
    else
      respond_with(@project_access)
    end
  end

  # DELETE /projects/1/stages/1
  # DELETE /projects/1/stages/1.xml
  def destroy
    @project_access = ProjectAccess.where(:project_id => current_project, :user_id => params[:id]).first
    @project_access.delete_logically_with_asscociation
    add_activity_for(@project_access, 'deleted')
    
    respond_with(current_project, :location => current_project, :notice => 'User was successfully removed from project.')
  end

end
