class CommitsController < ApplicationController
  def index
    @commits = Commit.all
  end

  def show
    @commit = Commit.find(params[:id])
  end
end
