class CommitsController < ApplicationController
  def index
    @commits = Commit.includes(:repository)
  end

  def show
    @commit = Commit.find(params[:id])
  end

  def create
    CommitsFetch.perform_async
    redirect_to commits_path, notice: t('common.request_sent')
  end
end
