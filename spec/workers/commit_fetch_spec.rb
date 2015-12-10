require 'rails_helper'

RSpec.describe CommitFetch do
  describe '#perform' do
    let(:fake_client) { double }
    let(:commit_json) { JSON(File.read("#{Rails.root}/spec/fixtures/commit.json")) }
    let(:files_json) { commit_json['files'] }
    let(:repository) { create(:repository) }
    let(:commit) { create(:commit, repository: repository) }

    before do
      allow(fake_client).to receive(:commit).with(repository.full_name, commit.sha, per_page: GITHUB_ENV['results_per_page']).and_return(commit_json)
      $client = fake_client
      subject.perform(commit.sha)
    end

    it 'fetches all file changes' do
      expect(commit.file_changes.count).to eq files_json.count
      commit_json['files'].each do |file_json|
        expect(commit.file_changes).to be_exists filename: file_json['filename'], patch: file_json['patch']
      end
    end
  end
end
