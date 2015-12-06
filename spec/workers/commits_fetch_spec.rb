require 'rails_helper'

RSpec.describe CommitsFetch do
  COMMIT_ATTRIBUTES = %w(sha committer committed_at message)

  describe '#perform' do
    let(:json1) do
      {
        'sha' => sha,
        'committer' => {
          'login' => committer
        },
        'commit' => {
          'author' => {
            'date' => committed_at
          }
        },
        'message' => message
      }
    end

    let(:json2) do
      {
        'sha' => 'sha2',
        'committer' => {
          'login' => 'anotheruser'
        },
        'commit' => {
          'author' => {
            'date' => DateTime.parse('2015-10-10')
          }
        },
        'message' => 'another message'
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

    before do
      allow(fake_client).to receive(:branches).with(repository.full_name, page: 1, per_page: GITHUB_ENV['results_per_page']).and_return(branches)
      allow(fake_client).to receive(:branches).with(repository.full_name, page: 2, per_page: GITHUB_ENV['results_per_page'])
      allow(fake_client).to receive(:commits_since).with(repository.full_name, anything, branches.second['name']).and_return([json1])
      allow(fake_client).to receive(:commits_since).with(repository.full_name, anything, unwatch_branch.name).and_return([json2])
      $client = fake_client
    end

    it 'fetches new commits of the non-unwatched branches' do
      expect {
        subject.perform
      }.to change(Commit, :count).by(1)

      COMMIT_ATTRIBUTES.each do |key|
        expect(new_commit.send(key)).to eq send(key)
      end
    end
  end
end
