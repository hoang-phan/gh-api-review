require 'rails_helper'

RSpec.describe RepositoryCommitsFetch do
  COMMIT_ATTRIBUTES = %w(sha committer committed_at message)

  describe '#perform' do
    let(:watched_json) do
      {
        'sha' => sha,
        'commit' => {
          'author' => {
            'date' => committed_at
          },
          'message' => message,
          'committer' => {
            'login' => committer
          }
        }
      }
    end

    let(:existing_json) do
      {
        'sha' => existing_sha,
        'commit' => {
          'author' => {
            'date' => committed_at
          },
          'message' => message,
          'committer' => {
            'login' => 'new commiter'
          }
        }
      }
    end

    let(:unwatched_json) do
      {
        'sha' => 'sha2',
        'commit' => {
          'author' => {
            'date' => DateTime.parse('2015-10-10')
          },
          'message' => 'another message',
          'committer' => {
            'login' => 'anotheruser'
          }
        }
      }
    end

    let(:fake_client) { double }
    let(:branches) { JSON(File.read("#{Rails.root}/spec/fixtures/branches.json")) }
    let!(:unwatch_branch) { create(:branch, repository: repository, watched: false, name: branches.first['name']) }
    let(:repository) { create(:repository, watched: true) }
    let(:sha) { Faker::Number.hexadecimal(8) }
    let(:committer) { Faker::Internet.user_name }
    let(:committed_at) { DateTime.parse('2015-10-10') }
    let(:new_commit) { Commit.last }
    let(:message) { Faker::Lorem.sentence }
    let(:existing_sha) { 'existing_sha' }
    let!(:existing_commit) { create(:commit, sha: existing_sha) }

    before do
      allow(fake_client).to receive(:branches).with(repository.full_name, page: 1, per_page: GITHUB_ENV['results_per_page']).and_return(branches)
      allow(fake_client).to receive(:branches).with(repository.full_name, page: 2, per_page: GITHUB_ENV['results_per_page'])
      allow(fake_client).to receive(:commits_since).with(repository.full_name, anything, branches.second['name']).and_return([watched_json])
      allow(fake_client).to receive(:commits_since).with(repository.full_name, anything, unwatch_branch.name).and_return([unwatched_json])
      $client = fake_client
    end

    it 'fetches new commits of the non-unwatched branches' do
      expect {
        subject.perform(repository.id)
      }.to change(repository.commits, :count).by(1)

      COMMIT_ATTRIBUTES.each do |key|
        expect(new_commit.send(key)).to eq send(key)
      end
    end
  end
end
