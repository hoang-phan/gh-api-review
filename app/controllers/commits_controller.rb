class CommitsController < ApplicationController
  def index
    @commits = Commit.includes(:repository).from_newest
  end

  def show
    @commit = Commit.find(params[:id])
    @line_comments = @commit.line_comments
  end

  def create
    CommitsFetch.perform_async
    redirect_to commits_path, notice: t('common.request_sent')
  end
end
