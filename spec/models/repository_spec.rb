require 'rails_helper'

RSpec.describe Repository, type: :model do
  it { is_expected.to have_many(:branches).dependent(:destroy) }

  describe 'default_scope' do
    it 'returns only watched repository' do
      expect(Repository.all.to_sql).to eq Repository.unscoped.order(:id).to_sql
    end
  end

  describe '.watched' do
    it 'returns only watched repository' do
      expect(Repository.watched.to_sql).to eq Repository.where(watched: true).to_sql
    end
  end

  describe '#watched_string' do
    subject { build_stubbed(:repository, watched: watched).watched_string }

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
