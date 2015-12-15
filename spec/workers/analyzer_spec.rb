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
          line_4 => [value_4]
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
        }      
      ]
    end

    let(:expected_result) do
      {
        line_1=>[rule1_name], 
        line_2=>[rule2_name], 
        line_3=>[rule1_name, rule2_name]
      }
    end

    let(:line_1) { '5' }
    let(:line_2) { '10' }
    let(:line_3) { '11' }
    let(:line_4) { '13' }
    let(:value_1) { 'matching 1 and sth' }
    let(:value_2) { 'matching 2' }
    let(:value_3) { 'matching 1 and matching 2' }
    let(:value_4) { 'nomatch' }
    let(:rule1_name) { Faker::Name.name }
    let(:rule2_name) { Faker::Name.name }

    before do
      stub_const('LINE_RULES', rules)
      subject.perform(commit.id)
    end

    it 'updates suggestions with correct result' do
      expect(file_change.reload.suggestions).to eq expected_result
    end
  end
end
