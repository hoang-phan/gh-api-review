class BranchesController < ApplicationController
  before_action :set_branch, only: :update

  def create
    BranchesFetch.perform_async(params[:repository_id])
    flash[:notice] = t('common.request_sent')
    redirect_to repository_path(params[:repository_id])
  end

  def show
  end

  def update
    @branch.update(branch_params)
  end

  private
  def set_branch
    @branch = Branch.find_by(id: params[:id], repository_id: params[:repository_id])
  end

  def branch_params
    params.require(:branch).permit(:watched)
  end
end
