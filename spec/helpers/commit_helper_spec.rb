require 'rails_helper'

RSpec.describe CommitHelper, type: :helper do
  describe '#display_line_change' do
    subject { helper.display_line_change(key, value, special_class) }

    let(:special_class) { 'class' }
    let(:value) { [line, '1'] }
    let(:key) { '2' }
    let(:line) { Faker::Lorem.sentence }

    context 'unchanged line' do
      it { is_expected.to eq "<p><span class=\"line-number\">#{key.rjust(5)}</span><span class=\"line unchanged-line\">#{line}</span></p>" }
    end

    context 'changed line' do
      let(:value) { [line, '1', true] }

      it { is_expected.to eq "<p><span class=\"line-number\">#{key.rjust(5)}</span><span class=\"line #{special_class}\">#{line}</span></p>" }
    end
  end
end
