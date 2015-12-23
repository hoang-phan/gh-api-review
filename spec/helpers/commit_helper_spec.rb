require 'rails_helper'

RSpec.describe CommitHelper, type: :helper do
  describe '#display_line_change' do
    subject { helper.display_line_change(key, value, special_class) }

    let(:special_class) { 'class' }
    let(:value) { [line, '1'] }
    let(:key) { '2' }
    let(:line) { Faker::Lorem.sentence }

    context 'unchanged line' do
      it { is_expected.to eq "<p><span class=\"line-number\">#{key.rjust(4)}</span><span class=\"line unchanged-line\">#{line}</span></p>" }
    end

    context 'changed line' do
      let(:value) { [line, '1', true] }

      it { is_expected.to eq "<p><span class=\"line-number\">#{key.rjust(4)}</span><span class=\"line #{special_class}\">#{line}</span></p>" }
    end
  end

  describe '#show_comment?' do
    subject { helper.show_comment?(is_modified, klass) }

    let(:is_modified) { false }
    let(:klass) { 'removed-line' }

    context 'is modified' do
      let(:is_modified) { true }

      it { is_expected.to be_truthy }
    end

    context 'class is added-line' do
      let(:klass) { 'added-line' }

      it { is_expected.to be_truthy }
    end

    context 'otherwise' do
      it { is_expected.to be_falsey }
    end
  end

  describe '#display_comments' do
    let(:line_comments) do
      {
        filename => {
          line => comments
        }
      }
    end

    let(:result) { helper.display_comments(line_comments, filename, line, is_modified, klass) }
    let(:is_modified) { false }
    let(:klass) { 'class-name' }
    let(:filename) { 'dir/filename.ext' }
    let(:line) { 3 }
    let(:comments) { ['my comment 1', 'my comment 2'] }
    let(:show_comment) { true }

    before do
      expect(helper).to receive(:show_comment?).with(is_modified, klass).and_return(show_comment)
    end

    context 'comment not shown' do
      let(:show_comment) { false }

      it 'returns nil' do
        expect(helper).not_to receive(:render)
        expect(result).to be_nil
      end
    end

    context 'comment not exists' do
      let(:comments) { [] }

      it 'returns nil' do
        expect(helper).not_to receive(:render)
        expect(result).to be_nil
      end
    end

    context 'comment exists' do
      let(:partial) { 'My partial' }

      it 'renders comment partial' do
        expect(helper).to receive(:render).with('file_changes/comments', comments: comments).and_return(partial)
        expect(result).to eq partial
      end
    end
  end

  describe '#render_line_changes' do
    let(:line_changes) do
      {
        key1 => value1,
        key2 => value2
      }
    end

    let(:render_options_1) do
      {
        key: key1,
        value: value1,
        special_class: klass,
        filename: filename,
        line_suggestions: line_suggestions_1
      }
    end
    let(:render_options_2) do
      {
        key: key2,
        value: value2,
        special_class: klass,
        filename: filename,
        line_suggestions: line_suggestions_2
      }
    end

    let(:key1) { '1' }
    let(:key2) { '5' }
    let(:value1) { 'value1' }
    let(:value2) { 'value2' }
    let(:partial1) { 'partial1' }
    let(:partial2) { 'partial2' }
    let(:line_suggestions_1) { [] }
    let(:line_suggestions_2) { [] }

    let(:klass) { 'class' }
    let(:filename) { 'dir/filename' }

    before do
      expect(helper).to receive(:render).with('file_changes/line_change', render_options_1)
                          .and_return(partial1)
      expect(helper).to receive(:render).with('file_changes/line_change', render_options_2)
                          .and_return(partial2)
    end

    context 'suggestions for line are absent' do
      it 'renders all line changes partials with null line_suggestions' do
        expect(render_line_changes(line_changes, klass, filename)).to eq "#{partial1}#{partial2}"
      end
    end

    context 'suggestions for line are present' do
      let(:suggestions) { { key1 => line_raw_1 } }
      let(:line_raw_1) { [{'name' => suggest_1, 'matches' => []}] }
      let(:line_suggestions_1) { [[suggest_1, '']] }
      let(:suggest_1) { 'suggest_1' }

      it 'renders all line changes partials with the correct line_suggestions' do
        expect(render_line_changes(line_changes, klass, filename, suggestions)).to eq "#{partial1}#{partial2}"
      end
    end
  end

  describe '#random_comments' do
    let(:comments) do
      {
        key => [value]
      }
    end

    let(:key) { 'key' }
    let(:value) { "<0><2><0>" }
    let(:suggestion) { [key, ['aa', 'b', 'cc'].join('<,>')] }

    before do
      stub_const('RANDOM_COMMENTS', comments)
    end

    it 'render correct templates' do
      expect(random_comments(suggestion)).to eq 'aaccaa'
    end
  end
end
