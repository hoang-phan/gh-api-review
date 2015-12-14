class SnippetsController < ApplicationController
  ALL_SNIPPETS = YAML.load_file(Rails.root.join('config', 'snippets.yml'))

  def index
    render json: { snippets: ALL_SNIPPETS }
  end
end
