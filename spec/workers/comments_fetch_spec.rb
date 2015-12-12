require 'rails_helper'

RSpec.describe CommentsFetch do
  describe '#perform' do
    let(:fake_client) { double }
    let(:comments_json) { JSON(File.read("#{Rails.root}/spec/fixtures/comments.json")) }
    let(:repository) { create(:repository) }
    let(:commit) { create(:commit, repository: repository) }

    before do
      allow(fake_client).to receive(:commit_comments).with(repository.full_name, commit.sha, per_page: GITHUB_ENV['results_per_page']).and_return(comments_json)
      $client = fake_client
      subject.perform(commit.sha)
    end

    it 'fetches all file changes' do
      expect(commit.comments.count).to eq comments_json.count
      comments_json.each do |comment|
        expect(commit.comments).to be_exists({
          external_id: comment['id'],
          filename: comment['path'],
          body: comment['body'],
          user: comment['user']['login'],
          line: comment['line']
        })
      end
    end
  end
end