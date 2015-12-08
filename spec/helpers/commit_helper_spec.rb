require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#display_line' do
    subject { helper.display_line(line) }

    let(:line) { 'line' }

    context 'line starts with +' do
      let(:line) { '+line' }

      it { is_expected.to eq content_tag(:span, line, class: 'added-line') }
    end

    context 'line starts with -' do
      let(:line) { '-line' }

      it { is_expected.to eq content_tag(:span, line, class: 'removed-line') }
    end

    context 'otherwise' do
      it { is_expected.to eq content_tag(:span, line, class: 'unchanged-line') }
    end
  end
end
