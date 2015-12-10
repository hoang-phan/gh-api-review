class CommentsController < ApplicationController
  def new
    @line_number = params[:line_number]
    @sha = params[:sha]
    @repo = params[:repo]
    render partial: 'new'
  end

  def create
  end 
end
