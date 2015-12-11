class CommentsController < ApplicationController
  def new
    @line = params[:line]
    @filename = params[:filename]
    commit = Commit.find(params[:commit_id])
    @sha = commit.sha
    @repo = commit.repository.full_name
    
    render partial: 'new'
  end

  def create
    $client.create_commit_comment(params[:repo], params[:sha], params[:body], params[:filename], nil, params[:line].to_i)
  end
end
