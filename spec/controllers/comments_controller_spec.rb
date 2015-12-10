require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "GET new" do
    let(:params) { { line_number: line_number, sha: sha, repo: repo } }
    let(:line_number) { '7' }
    let(:sha) { 'sha' }
    let(:repo) { 'repo' }

    it "renders partial view" do
      get :new, params
      expect(assigns(:line_number)).to eq line_number 
      expect(assigns(:repo)).to eq repo 
      expect(assigns(:sha)).to eq sha 
      expect(response).to render_template(partial: 'comments/_new')
    end
  end
end
