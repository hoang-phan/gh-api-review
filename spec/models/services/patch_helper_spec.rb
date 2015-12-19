require 'rails_helper'

RSpec.describe PatchHelper do
  describe '#process_patch' do
    let(:patch) { "@@ -10,2 +10,2 @@line 1\n+line 2\n-line 3\nline 4\n@@ -18,1 +18,2 @@line 5\nline 6\n+line7" }
    let(:line_changes) do
      [
        {
          '+' => {
            10 => ['+line 2', 1, true],
            11 => ['line 4', 3]
          },
          '-' => {
            10 => ['-line 3', 2, true],
            11 => ['line 4', 3]
          }, 
          'header' => '@@ -10,2 +10,2 @@line 1'
        },
        {
          '+' => {
            18 => ['line 6', 5],
            19 => ['+line7', 6, true]
          },
          '-' => {
            18 => ['line 6', 5]
          }, 
          'header' => '@@ -18,1 +18,2 @@line 5'
        }
      ]
    end

    context 'patch is not null' do
      it 'returns hash of patch' do
        expect(described_class.build_patch(patch)).to eq line_changes
      end
    end

    context 'patch is null' do
      let(:patch) { nil }

      it 'returns empty array' do
        expect(described_class.build_patch(patch)).to eq []
      end
    end
  end
end
