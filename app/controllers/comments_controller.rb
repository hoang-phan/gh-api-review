class CommentsController < ApplicationController
  def new
    render partial: 'new', locals: partial_params
  end

  def create
    $client.create_commit_comment(params[:repo], params[:sha], params[:body], params[:filename], nil, params[:line].to_i)
    CommentsFetch.perform_async(params[:sha])
  end

  private
  def partial_params
    params.slice(:line, :filename).merge({
      sha: commit.sha,
      repo: commit.repository.full_name,
      body: nil,
      suggestions: {}
    })
  end

  def commit
    @commit ||= Commit.find(params[:commit_id])
  end
end
