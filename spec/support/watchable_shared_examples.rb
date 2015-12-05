shared_examples_for 'watchable' do
  describe '.watched' do
    it 'returns only watched repository' do
      expect(described_class.watched.to_sql).to eq described_class.where(watched: true).to_sql
    end
  end

  describe '#watched_string' do
    subject { described_class.new(watched: watched).watched_string }

    let(:watched) { false }

    context 'watched is false' do
      it { is_expected.to eq described_class::STRING_UNWATCHED}
    end

    context 'watched is true' do
      let(:watched) { true }

      it { is_expected.to eq described_class::STRING_WATCHED}
    end
  end
end