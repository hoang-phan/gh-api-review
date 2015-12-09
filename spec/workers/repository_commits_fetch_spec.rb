require 'rails_helper'

RSpec.describe RepositoryCommitsFetch do
  describe '#perform' do
    let(:watched_json1) do
      {
        'sha' => sha,
        'commit' => {
          'author' => {
            'date' => committed_at
          },
          'message' => message
        },
        'committer' => {
          'login' => committer
        }
      }
    end

    let(:watched_json2) do
      {
        'sha' => sha1,
        'commit' => {
          'author' => {
            'date' => committed_at
          },
          'message' => message,
          'committer' => {
            'name' => committer_name
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
            'name' => 'new committer'
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
            'name' => 'anotheruser'
          }
        }
      }
    end

    let(:fake_client) { double }
    let(:branches) { JSON(File.read("#{Rails.root}/spec/fixtures/branches.json")) }
    let!(:unwatch_branch) { create(:branch, repository: repository, watched: false, name: branches.first['name']) }
    let(:repository) { create(:repository, watched: true) }
    let(:sha) { Faker::Number.hexadecimal(8) }
    let(:sha1) { Faker::Number.hexadecimal(8) }
    let(:committer) { Faker::Internet.user_name }
    let(:committer_name) { Faker::Name.name }
    let(:committed_at) { DateTime.parse('2015-10-10') }
    let(:message) { Faker::Lorem.sentence }
    let(:existing_sha) { 'existing_sha' }
    let!(:existing_commit) { create(:commit, sha: existing_sha) }

    before do
      allow(fake_client).to receive(:branches).with(repository.full_name, page: 1, per_page: GITHUB_ENV['results_per_page']).and_return(branches)
      allow(fake_client).to receive(:branches).with(repository.full_name, page: 2, per_page: GITHUB_ENV['results_per_page'])
      allow(fake_client).to receive(:commits_since).with(repository.full_name, anything, branches.second['name']).and_return([watched_json1, watched_json2])
      allow(fake_client).to receive(:commits_since).with(repository.full_name, anything, unwatch_branch.name).and_return([unwatched_json])
      $client = fake_client
    end

    it 'fetches new commits of the non-unwatched branches' do
      expect {
        subject.perform(repository.id)
      }.to change(repository.commits, :count).by(2)

      expect(repository.commits).to be_exists(sha: sha, committer: committer, message: message, committed_at: committed_at)
      expect(repository.commits).to be_exists(sha: sha1, committer: committer_name, message: message, committed_at: committed_at)
    end
  end
end
