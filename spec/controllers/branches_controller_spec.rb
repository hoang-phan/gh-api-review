require 'rails_helper'

RSpec.describe BranchesController, type: :controller do

  describe "POST create" do
    let(:repository) { create(:repository) }

    it 'fetches branches of the repositories' do
      expect(BranchesFetch).to receive(:perform_async).with(repository.id.to_s)
      post :create, repository_id: repository.id
      expect(response).to redirect_to repository_path(repository)
      expect(flash[:notice]).to eq I18n.t('common.request_sent')
    end
  end
end
