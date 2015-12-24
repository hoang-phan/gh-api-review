require 'rails_helper'

RSpec.describe CommitsController, type: :controller do

  describe "GET index" do
    let(:commit_1) { create(:commit) }
    let(:commit_2) { create(:commit) }
    let!(:comments_1) { create_list(:comment, num_of_comment_1, commit: commit_1) }
    let!(:comments_2) { create_list(:comment, num_of_comment_2, commit: commit_2) }
    let(:num_of_comment_1) { 2 }
    let(:num_of_comment_2) { 1 }
    let(:expected_result) do
      {
        commit_1.id => num_of_comment_1,
        commit_2.id => num_of_comment_2
      }
    end

    it "returns http success" do
      get :index
      expect(response).to be_success
      expect(assigns(:commits)).to match_array([commit_1, commit_2])
      expect(assigns(:comments_count)).to eq expected_result
    end
  end

  describe "GET show" do
    let(:commit) { create(:commit) }

    it "returns http success" do
      get :show, id: commit.id
      expect(response).to be_success
      expect(assigns(:commit)).to eq commit
    end
  end

  describe "POST create" do
    it "returns http success" do
      expect(CommitsFetch).to receive(:perform_async)
      post :create
      expect(response).to redirect_to(commits_path)
      expect(flash[:notice]).to eq I18n.t('common.request_sent')
    end
  end
end
