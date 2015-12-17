require 'rails_helper'

RSpec.describe Analyzer do

  describe '#perform' do
    let(:commit) { create(:commit) }
    let!(:file_change) { create(:file_change, line_changes: line_changes, filename: 'sample.rb', commit: commit) }
    let(:line_changes) do
      {
        '+' => {
          line_1 => [value_1],
          line_2 => [value_2],
          line_3 => [value_3],
          line_4 => [value_4],
          line_5 => [value_5]
        }
      }
    end

    let(:rules) do
      [
        {
          'regex' => {
            'rb' => 'matching 1'
          },
          'name' => rule1_name
        },
        {
          'regex' => {
            'all' => 'matching 2'
          },
          'name' => rule2_name
        },
        {
          'regex' => {
            'all' => 'matching 3'
          },
          'name' => rule3_name,
          'offset' => 1
        }
      ]
    end

    let(:expected_result) do
      {
        line_1 => [rule1_name], 
        line_2 => [rule2_name], 
        line_3 => [rule1_name, rule2_name],
        (line_5.to_i - 1).to_s => [rule3_name] 
      }
    end

    let(:line_1) { '5' }
    let(:line_2) { '10' }
    let(:line_3) { '11' }
    let(:line_4) { '13' }
    let(:line_5) { '17' }
    let(:value_1) { 'matching 1 and sth' }
    let(:value_2) { 'matching 2' }
    let(:value_3) { 'matching 1 and matching 2' }
    let(:value_4) { 'nomatch' }
    let(:value_5) { 'matching 3' }
    let(:rule1_name) { Faker::Name.name }
    let(:rule2_name) { Faker::Name.name }
    let(:rule3_name) { Faker::Name.name }

    before do
      stub_const('LINE_RULES', rules)
      subject.perform(commit.id)
    end

    it 'updates suggestions with correct result' do
      expect(file_change.reload.suggestions).to eq expected_result
    end
  end
end
