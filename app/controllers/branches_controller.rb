class BranchesController < ApplicationController
  def create
    BranchesFetch.perform_async(params[:repository_id])
    flash[:notice] = t('common.request_sent')
    redirect_to repository_path(params[:repository_id])
  end

  def show
  end

  def update
  end
end
