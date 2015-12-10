require 'rails_helper'

RSpec.describe CommitHelper, type: :helper do
  describe '#display_line_change' do
    subject { helper.display_line_change(line_changes, special_class) }
    let(:special_class) { 'class' }
    let(:line_changes) do
      {
        key_1 => [line_1],
        key_2 => [line_2, true]
      }
    end
    let(:key_1) { '1' }
    let(:key_2) { '2' }
    let(:line_1) { Faker::Lorem.sentence }
    let(:line_2) { Faker::Lorem.sentence }

    it { is_expected.to eq "<p><span class=\"line-number\">#{key_1.rjust(5)}</span><span class=\"line unchanged-line\">#{line_1}</span></p><p><span class=\"line-number\">#{key_2.rjust(5)}</span><span class=\"line #{special_class}\">#{line_2}</span></p>" }
  end
end
