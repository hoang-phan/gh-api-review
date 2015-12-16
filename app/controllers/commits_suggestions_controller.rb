class CommitsSuggestionsController < ApplicationController
  def index
    render json: { comments: RANDOM_COMMENTS }
  end

  def create
    Commit.pluck(:id).each do |commit_id|
      Analyzer.perform_async(commit_id)
    end
    redirect_to commits_path, notice: t('common.request_sent')
  end
end
