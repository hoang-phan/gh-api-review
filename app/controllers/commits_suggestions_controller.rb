class CommitsSuggestionsController < ApplicationController
  def index
    render json: { comments: FileChange.build_random_comments }
  end

  def create
    Commit.pluck(:id).each do |commit_id|
      Analyzer.perform_async(commit_id)
    end
    redirect_to commits_path, notice: t('common.request_sent')
  end
end
