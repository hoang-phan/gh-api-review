require 'rails_helper'

RSpec.describe CommitsSuggestionsController, type: :controller do
  describe "GET index" do
    let(:json) { JSON.parse(response.body) }

    it "returns all snippets" do
      get :index
      expect(response).to be_success
      expect(json['comments']).to eq RANDOM_COMMENTS
    end
  end

  describe "POST create" do
    let(:commits) { create_list(:commit, 2) }

    it 'analyzes all commits' do
      commits.map(&:id).each do |id|
        expect(Analyzer).to receive(:perform_async).with(id)
      end
      post :create
      expect(response).to redirect_to commits_path
      expect(flash[:notice]).to eq I18n.t('common.request_sent')
    end
  end
end
