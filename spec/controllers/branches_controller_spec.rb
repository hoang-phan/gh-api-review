require 'rails_helper'

RSpec.describe BranchesController, type: :controller do
  let(:repository) { create(:repository) }

  describe "POST create" do
    it 'fetches branches of the repositories' do
      expect(BranchesFetch).to receive(:perform_async).with(repository.id.to_s)
      post :create, repository_id: repository.id
      expect(response).to redirect_to repository_path(repository)
      expect(flash[:notice]).to eq I18n.t('common.request_sent')
    end
  end

  describe 'PUT update' do
    let(:params) do 
      {
        branch: { watched: watched }, 
        id: branch.id,
        repository_id: repository.id,
        format: :js
      }
    end

    let!(:branch) { create(:branch, repository: repository) }
    let(:watched) { true }

    it 'updates successfully' do
      expect {
        put :update, params
      }.to change(Branch.watched, :count).by(1)
      expect(response).to render_template(:update)
    end
  end
end
