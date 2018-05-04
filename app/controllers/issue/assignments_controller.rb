class Issue::AssignmentsController < ApplicationController
  before_action :authorize_assignment!

  # POST /issue/:issue_id/assignment
  def create
    if issue.update(assignee: current_user)
      render json: issue, status: :created, location: issue
    else
      render json: issue.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /issue/:issue_id/assignment
  def update
    if issue.update(assignment_params)
      render json: issue
    else
      render json: issue.errors, status: :unprocessable_entity
    end
  end

  # DELETE /issue/:issue_id/assignment
  def destroy
    raise CanCan::AccessDenied unless issue.pending?
    issue.update(assignee: nil)
  end

  private

  def authorize_assignment!
    authorize! :assignment, issue
  end

  def issue
    @issue = Issue.accessible_by(current_ability).find(params[:issue_id])
  end

  def assignment_params
    params.require(:assignment).permit(:status)
  end
end
