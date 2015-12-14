require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { is_expected.to belong_to(:commit) }

  describe '.from_oldest' do
    it 'sorted from oldest' do
      expect(described_class.from_oldest.to_sql).to eq described_class.order(commented_at: :asc).to_sql
    end
  end
end
