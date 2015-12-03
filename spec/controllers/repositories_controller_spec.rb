require 'rails_helper'

RSpec.describe RepositoriesController, type: :controller do
  describe "GET index" do
    it 'returns all repositories' do
      get :index
      expect(response).to be_success
      expect(assigns(:repositories).to_sql).to eq Repository.all.to_sql
    end
  end

  describe "POST create" do
    it 'fetches all repositories' do
      post :create
      expect(response).to redirect_to(repositories_path)
      expect(flash[:notice]).to eq 'Request sent. Please reload page later'
    end
  end
end
