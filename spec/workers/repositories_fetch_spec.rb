require 'rails_helper'

RSpec.describe RepositoriesFetch do

  describe '#perform' do
    let(:fake_client) { double(repositories: repositories) }
    let(:repositories) { JSON(File.read("#{Rails.root}/spec/fixtures/repos.json")) }
    let(:branch_name) { 'master' }
    let(:branches) do
      [
        {
          'name' => branch_name
        }
      ]
    end

    before do
      allow(fake_client).to receive(:branches).and_return(branches)
      $client = fake_client

      subject.perform
    end

    it 'fetch all repositories with all of its branch' do
      repositories.each do |repo|
        repository = Repository.find_by(full_name: repo['full_name'])
        expect(repository).to be_present
        expect(repository.branches).to be_exists(name: branch_name)
      end
    end
  end
end
