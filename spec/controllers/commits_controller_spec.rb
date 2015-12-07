require 'rails_helper'

RSpec.describe CommitsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to be_success
      expect(assigns(:commits).to_sql).to eq Commit.all.to_sql
    end
  end

  describe "GET #show" do
    let(:commit) { create(:commit) }

    it "returns http success" do
      get :show, id: commit.id
      expect(response).to be_success
      expect(assigns(:commit)).to eq commit
    end
  end
end