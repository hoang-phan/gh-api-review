require 'rails_helper'

RSpec.describe CommitsFetch do
  describe '#perform' do
    let(:repository1) { create(:repository, watched: true) }
    let(:repository2) { create(:repository, watched: false) }

    after do
      subject.perform
    end

    it 'fetch all commits of watched repositories' do
      expect(RepositoryCommitsFetch).to receive(:perform_async).with(repository1.id)
      expect(RepositoryCommitsFetch).not_to receive(:perform_async).with(repository2.id)
    end
  end
end
