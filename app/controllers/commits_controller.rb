class CommitsController < ApplicationController
  def index
    @commits = Commit.includes(:repository)
  end

  def show
    @commit = Commit.find(params[:id])
  end
end
