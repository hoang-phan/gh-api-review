require 'rails_helper'

RSpec.describe PatchHelper do
  describe '#process_patch' do
    let(:patch) { "@@ -10,3 +10,3 @@line 1\n+line 2\n-line 3\nline 4\n@@ -18,1 +18,2 @@+line 5\nline 6" }
    let(:line_changes) do
      {
        '+' => {
          10 => ['line 1'],
          11 => ['+line 2', true],
          12 => ['line 4'],
          18 => ['+line 5', true],
          19 => ['line 6']
        },
        '-' => {
          10 => ['line 1'],
          11 => ['-line 3', true],
          12 => ['line 4'],
          18 => ['line 6']
        }
      }
    end

    context 'patch is not null' do
      it 'returns hash of patch' do
        expect(described_class.build_patch(patch)).to eq line_changes
      end
    end

    context 'patch is null' do
      let(:patch) { nil }

      it 'returns empty hash' do
        expect(described_class.build_patch(patch)).to eq({})
      end
    end
  end
end
