require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "GET new" do
    let(:params) { { line: line, commit_id: commit.id, filename: filename } }
    let(:commit) { create(:commit) }
    let(:filename) { 'filename' }
    let(:line) { '7' }

    it "renders partial view" do
      allow(controller).to receive(:render).with no_args
      expect(controller).to receive(:render).with(partial: 'new', locals: {
        'line' => line,
        'filename' => filename,
        'sha' => commit.sha,
        'repo' => commit.repository.full_name,
        'body' => nil,
        'suggestions' => {}
      })
      get :new, params
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
