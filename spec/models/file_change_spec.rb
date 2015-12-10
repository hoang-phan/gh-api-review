require 'rails_helper'

RSpec.describe FileChange, type: :model do
  it { is_expected.to belong_to :commit }

  describe '#process_patch' do
    let(:file_change) { described_class.create(patch: patch) }

    let(:patch) { "@@ -10,3 +10,3 @@line 1\n+line 2\n-line 3\nline 4\n@@ -18,1 +18,2 @@+line 5\nline 6" }
    let(:line_changes) do
      {
        '+' => {
          '10' => ['line 1'],
          '11' => ['+line 2', true],
          '12' => ['line 4'],
          '18' => ['+line 5', true],
          '19' => ['line 6']
        },
        '-' => {
          '10' => ['line 1'],
          '11' => ['-line 3', true],
          '12' => ['line 4'],
          '18' => ['line 6']
        }
      }
    end

    it 'updates line_changes and patch' do
      expect(file_change.patch).to eq patch
      expect(file_change.line_changes).to eq line_changes
    end
  end
end
