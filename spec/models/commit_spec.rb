require 'rails_helper'

RSpec.describe Commit, type: :model do
  it { is_expected.to belong_to(:repository) }
  it { is_expected.to have_many(:file_changes).dependent(:destroy) }

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
end
