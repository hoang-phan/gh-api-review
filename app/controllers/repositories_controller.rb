class RepositoriesController < ApplicationController
  before_action :set_repository, only: :show

  def index
    @repositories = Repository.all
  end

  def create
    RepositoriesFetch.perform_async
    flash[:notice] = 'Request sent. Please reload page later'
    redirect_to repositories_path
  end

  def show
  end

  private
  def set_repository
    @repository = Repository.find(params[:id])
  end
end
