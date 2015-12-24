class CommitsController < ApplicationController
  def index
    @commits = Commit.includes(:repository).from_newest
    @comments_count = Comment.group(:commit_id).count
  end

  def show
    @commit = Commit.find(params[:id])
    @repository = @commit.repository
    @line_comments = @commit.line_comments
    @random_comments = FileChange.build_random_comments
  end

  def create
    CommitsFetch.perform_async
    redirect_to commits_path, notice: t('common.request_sent')
  end
end
