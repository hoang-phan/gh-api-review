require 'rails_helper'

RSpec.describe BranchesFetch do

  describe '#perform' do
    let(:fake_client) { double(branches: branches) }
    let(:branches) { JSON(File.read("#{Rails.root}/spec/fixtures/branches.json")) }
    let!(:obsolete_branch) { create(:branch, repository: repository) }
    let!(:existing_branch) { create(:branch, repository: repository, watched: true, name: branches.first['name']) }
    let(:repository) { create(:repository) }

    before do
      $client = fake_client
      subject.perform(repository.id)
    end

    it 'keeps existing branches' do
      expect(repository.branches).to be_exists(name: branches.first['name'], watched: true)
    end

    it 'fetches new branches' do
      expect(repository.branches).to be_exists(name: branches.second['name'], watched: false)
    end

    it 'deletes obsolete branches' do
      expect(repository.branches).not_to be_exists(name: obsolete_branch.name)
    end
  end
end
