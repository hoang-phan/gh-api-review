require 'rails_helper'

RSpec.describe Commit, type: :model do
  it { is_expected.to belong_to(:repository) }
  it { is_expected.to have_many(:file_changes) }
  it { is_expected.to have_many(:comments) }

  describe '.from_newest' do
    it 'sorted from newest' do
      expect(described_class.from_newest.to_sql).to eq described_class.order(committed_at: :desc).to_sql
    end
  end

  describe '#github_url' do
    let(:repository) { create(:repository) }
    let(:commit) { build(:commit, repository: repository) }

    it 'returns correct url' do
      expect(commit.github_url).to eq "https://github.com/#{repository.full_name}/commit/#{commit.sha}"
    end
  end

  describe '#short_message' do
    let(:commit) { build(:commit, message: message) }
    let(:message) { "abc\nxyz" }

    it 'returns first line of message' do
      expect(commit.short_message).to eq "abc"
    end
  end

  describe '#line_comments' do
    let(:commit) { create(:commit) }
    let(:filename) { 'dir/file' }
    let(:line) { 10 }
    let!(:comment_1) { create(:comment, filename: filename, line: line, commit: commit, commented_at: Time.parse('2012/12/11 11:22:33')) }
    let!(:comment_2) { create(:comment, filename: filename, line: line, commit: commit, commented_at: Time.parse('2012/12/11 11:11:11')) }
    let(:result) { commit.line_comments }

    it 'returns hash of comments base on filename and line' do
      expect(commit.line_comments[filename][line]).to eq [comment_2, comment_1].map { |c| [c.user, c.body, c.commented_at] }
    end
  end
end
