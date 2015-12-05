shared_examples_for 'sortable by id' do
  describe 'default_scope' do
    it 'returns only watched repository' do
      expect(described_class.all.to_sql).to eq described_class.unscoped.order(:id).to_sql
    end
  end
end