require 'rails_helper'

RSpec.describe CommitsSuggestionsController, type: :controller do
  describe "GET index" do
    let(:json) { JSON.parse(response.body) }
    let(:random_comments) { 'random_comments' }

    before do
      expect(FileChange).to receive(:build_random_comments).and_return(random_comments)
      get :index
    end

    it "returns all snippets" do
      expect(response).to be_success
      expect(json['comments']).to eq random_comments
    end
  end

  describe "POST create" do
    let(:commits) { create_list(:commit, 2) }

    before do
      commits.map(&:id).each do |id|
        expect(Analyzer).to receive(:perform_async).with(id)
      end
      post :create
    end

    it 'analyzes all commits' do
      expect(response).to redirect_to commits_path
      expect(flash[:notice]).to eq I18n.t('common.request_sent')
    end
  end
end
