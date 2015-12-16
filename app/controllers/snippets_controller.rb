class SnippetsController < ApplicationController
  def index
    render json: { snippets: ALL_SNIPPETS }
  end
end
