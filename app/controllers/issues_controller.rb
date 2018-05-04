class IssuesController < ApplicationController
  # GET /issues
  def index
    render json: issues
  end

  # GET /issues/1
  def show
    render json: issue
  end

  # POST /issues
  def create
    @issue = issues.new(issue_params)

    if issue.save
      render json: issue, status: :created, location: issue
    else
      render json: issue.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /issues/1
  def update
    if issue.update(issue_params)
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
    @issues ||= Issue.all
  end

  def issue
    @issue ||= issues.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def issue_params
    params.require(:issue).permit(:status, :author_id, :assignee_id)
  end
end
