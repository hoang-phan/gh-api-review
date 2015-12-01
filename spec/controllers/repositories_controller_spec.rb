require 'rails_helper'

RSpec.describe RepositoriesController, type: :controller do
  describe "GET #index" do
    it 'returns all repositories' do
      get :index
      expect(response).to be_success
      expect(assigns(:repositories).to_sql).to eq Repository.all.to_sql
    end
  end
end
