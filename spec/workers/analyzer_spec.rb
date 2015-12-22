require 'rails_helper'

RSpec.describe Analyzer do
  describe '#perform' do
    let(:commit_id) { 'commit_id' }
    let(:file_change_1) { double('FileChange1') }
    let(:file_change_2) { double('FileChange2') }
    let(:file_changes) { double }

    before do
      expect(FileChange).to receive(:where).with(commit_id: commit_id).and_return(file_changes)
      expect(file_changes).to receive(:find_each).and_yield(file_change_1).and_yield(file_change_2)
    end

    after do
      subject.perform(commit_id)
    end

    it 'calls analyze on file change' do
      expect(file_change_1).to receive(:analyze)
      expect(file_change_2).to receive(:analyze)
    end
  end
end
