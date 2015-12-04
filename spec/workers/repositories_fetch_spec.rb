require 'rails_helper'

RSpec.describe RepositoriesFetch do

  describe '#perform' do
    let(:fake_client) { double(organization_repositories: repositories) }
    let(:repositories) { JSON(File.read("#{Rails.root}/spec/fixtures/repos.json")) }
    let!(:obsolete_repository) { create(:repository) }
    let!(:existing_repository) { create(:repository, watched: true, full_name: repositories.first['full_name']) }

    before do
      $client = fake_client
      subject.perform
    end

    it 'keeps existing repositories' do
      expect(Repository).to be_exists(full_name: repositories.first['full_name'], watched: true)
    end

    it 'fetches new repositories' do
      expect(Repository).to be_exists(full_name: repositories.second['full_name'], watched: false)
    end

    it 'deletes obsolete repositories' do
      expect(Repository).not_to be_exists(full_name: obsolete_repository.full_name)
    end
  end
end
