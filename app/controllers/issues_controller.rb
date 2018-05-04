class IssuesController < ApplicationController
  authorize_resource

  # GET /issues
  def index
    # TODO: extract into Presenter to support metadata i.e. PAGE, MORE_RESULTS or use gem ransack

    scope = issues
    scope = scope.where(status: params[:status]) if params[:status].present?
    scope = scope.offset(params[:offset]) if params[:offset].present?

    render json: scope.order(created_at: :desc).limit(Issue::PER_PAGE)
  end

  # POST /issues
  def create
    @issue = issues.new(issue_params.merge(author_id: current_user.id))

    if issue.save
      render json: issue, status: :created, location: issue
    else
      render json: issue.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /issues/1
  def update
    if issue.update!(issue_params)
      render json: issue
    else
      render json: issue.errors, status: :unprocessable_entity
    end
  end

  # DELETE /issues/1
  def destroy
    issue.destroy
  end

  private

  def issues
    @issues ||= Issue.accessible_by(current_ability)
  end

  def issue
    @issue ||= issues.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:description)
  end
end
