require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "GET new" do
    let(:params) { { line: line, commit_id: commit.id } }
    let(:commit) { create(:commit) }
    let(:line) { '7' }

    it "renders partial view" do
      get :new, params
      expect(assigns(:line)).to eq line 
      expect(assigns(:repo)).to eq commit.repository.full_name
      expect(assigns(:sha)).to eq commit.sha 
      expect(response).to render_template(partial: 'comments/_new')
    end
  end

  describe 'POST create' do
    let(:params) do
      {
        repo: repo,
        sha: sha,
        filename: filename,
        body: body,
        line: line,
        format: :js
      }
    end
    let(:repo) { 'org/repo' }
    let(:filename) { 'filename' }
    let(:sha) { Faker::Number.hexadecimal(8) }
    let(:body) { Faker::Lorem.sentence }
    let(:line) { '1' }

    let(:fake_client) { double }

    it 'sends comment command to github' do
      expect(fake_client).to receive(:create_commit_comment).with(repo, sha, body, filename, nil, line.to_i)
      $client = fake_client
      post :create, params
      expect(response).to render_template(:create, format: :js)
    end
  end
end
