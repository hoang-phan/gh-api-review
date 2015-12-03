class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.all
  end

  def create
    RepositoriesFetch.perform_async
    flash[:notice] = 'Request sent. Please reload page later'
    redirect_to repositories_path
  end
end
