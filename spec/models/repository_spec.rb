require 'rails_helper'

RSpec.describe Repository, type: :model do
  it { is_expected.to have_many(:branches).dependent(:destroy) }

  describe '.watched' do
    it 'returns only watched repository' do
      expect(Repository.watched.to_sql).to eq Repository.where(watched: true).to_sql
    end
  end
end
