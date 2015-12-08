class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :update]

  def index
    @repositories = Repository.all
  end

  def create
    RepositoriesFetch.perform_async
    redirect_to repositories_path, notice: t('common.request_sent')
  end

  def show
  end

  def update
    @repository.update(repository_params)
  end

  private
  def set_repository
    @repository = Repository.find(params[:id])
  end

  def repository_params
    params.require(:repository).permit(:watched)
  end
end
