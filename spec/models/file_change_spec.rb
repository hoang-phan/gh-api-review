require 'rails_helper'

RSpec.describe FileChange, type: :model do
  it { is_expected.to belong_to :commit }

  describe '#analyze' do
    subject { build(:file_change, line_changes: line_changes, filename: 'sample.rb') }

    let(:line_changes) do
      [
        {
          '+' => {
            line_1 => [value_1],
            line_2 => [value_2],
            line_3 => [value_3]
          }
        },
        {
          '+' => {
            line_4 => [value_4],
            line_5 => [value_5]
          }
        }
      ]
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
      subject.analyze
    end

    it 'updates suggestions with correct result' do
      expect(subject.suggestions).to eq expected_result
    end
  end

  describe '#match_rules' do
    subject { build(:file_change, filename: "sample.#{extension}") }

    let(:matching) do
      Proc.new do |block|
        subject.send(:match_rules, line, ln, &block)
      end
    end

    let(:extension) { 'html' }
    let(:line) { '' }
    let(:ln) { '3' }

    context 'line is not present' do
      it { expect(matching).not_to yield_control }
    end

    context 'missing new line' do
      let(:line) { '\No newline at end of file' }

      it { expect(matching).to yield_with_args('2', 'New line warning') }
    end

    ['"string_#{ interpolate}"', '"string_#{interpolate }"', '"string_#{  interpolate }"'].each do |value|
      context value do
        let(:line) { value }

        it { expect(matching).to yield_with_args(ln, 'Extra space') }
      end
    end

    context 'missing space for erb' do
      let(:extension) { 'erb' }

      ["<% abc%>", "<%abc %>", "<%abc%>"].each do |value|
        context value do
          let(:line) { value }

          it { expect(matching).to yield_with_args(ln, 'Missing space') }
        end
      end
    end

    context 'missing space for hash' do
      ['{ "bc":123 }', "{ bc:'123' }"].each do |value|
        context value do
          let(:line) { value }

          %w(rb erb haml slim coffee js).each do |lang|
            context lang do
              let(:extension) { lang }

              it { expect(matching).to yield_with_args(ln, 'Missing space') }
            end
          end

          context 'otherwise' do
            let(:extension) { 'xml' }

            it { expect(matching).not_to yield_control }
          end
        end
      end

      [' :abc', 'Faker::Lorem'].each do |value|
        let(:extension) { 'rb' }

        context value do
          let(:line) { value }

          it { expect(matching).not_to yield_control }
        end
      end
    end

    context 'missing space after =' do
      let(:line) { 'span.class#id=method(args)' }

      %w(rb erb haml slim coffee js).each do |lang|
        context lang do
          let(:extension) { lang }

          it { expect(matching).to yield_with_args(ln, 'Missing space') }
        end
      end

      context 'otherwise' do
        it { expect(matching).not_to yield_control }
      end
    end

    [' {abc: 123 }', ' { abc: 123}', '{abc: 123}'].each do |value|
      context value do
        let(:line) { value }

        it { expect(matching).to yield_with_args(ln, 'Missing space') }
      end
    end

    ['{}', ' { }', '+#{value == 1}'].each do |value|
      context value do
        let(:line) { value }

        it { expect(matching).not_to yield_control }
      end
    end

    context 'starts with return plus' do
      let(:line) { "+  \treturn method" }

      %w(rb coffee).each do |lang|
        context lang do
          let(:extension) { lang }

          it { expect(matching).to yield_with_args(ln, 'Explicit return') }
        end
      end

      context 'otherwise' do
        let(:extension) { 'js' }

        it { expect(matching).not_to yield_control }
      end
    end

    context 'starts with return' do
      let(:line) { 'return method' }

      %w(rb coffee).each do |lang|
        context lang do
          let(:extension) { lang }

          it { expect(matching).to yield_with_args(ln, 'Explicit return') }
        end
      end

      context 'otherwise' do
        let(:extension) { 'js' }

        it { expect(matching).not_to yield_control }
      end
    end

    %w(text email file number hidden).each do |type|
      context "input with type #{type}" do
        context 'erb' do
          let(:extension) { 'erb' }
          let(:line) { "<input type='#{type}'>" }

          it { expect(matching).to yield_with_args(ln, "Use #{type} field tag") }
        end

        context 'haml' do
          let(:extension) { 'haml' }
          let(:line) { "%input{ type: '#{type}' }" }

          it { expect(matching).to yield_with_args(ln, "Use #{type} field tag") }
        end

        context 'slim' do
          let(:extension) { 'slim' }
          let(:line) { "input(type='#{type}')" }

          it { expect(matching).to yield_with_args(ln, "Use #{type} field tag") }
        end

        context 'otherwise' do
          let(:line) { "<input type='#{type}'>" }

          it { expect(matching).not_to yield_control }
        end
      end
    end

    context 'raw select tag' do
      { 'erb' => "<select class='abc'>", 'haml' => '%select.abc', 'slim' => 'select.abc' }.each do |lang, value|
        context lang do
          let(:extension) { lang }
          let(:line) { value }

          it { expect(matching).to yield_with_args(ln, 'Use select tag') }
        end
      end

      context 'otherwise' do
        let(:line) { "<select class='abc'>" }

        it { expect(matching).not_to yield_control }
      end
    end

    context 'raw img tag' do
      { 'erb' => "<img class='abc'>", 'haml' => '%img.abc', 'slim' => 'img.abc' }.each do |lang, value|
        context lang do
          let(:extension) { lang }
          let(:line) { value }

          it { expect(matching).to yield_with_args(ln, 'Use image tag') }
        end
      end

      context 'otherwise' do
        let(:line) { "<img class='abc'>" }

        it { expect(matching).not_to yield_control }
      end
    end

    context 'raw a tag' do
      { 'erb' => "<a class='abc'>", 'haml' => '%a.abc', 'slim' => 'a.abc' }.each do |lang, value|
        context lang do
          let(:extension) { lang }
          let(:line) { value }

          it { expect(matching).to yield_with_args(ln, 'Use link to') }
        end
      end

      context 'otherwise' do
        let(:line) { "<a class='abc'>" }

        it { expect(matching).not_to yield_control }
      end
    end

    context 'explicit div tag' do
      context 'haml' do
        let(:extension) { 'haml' }
        let(:line) { '%div.abc' }

        it { expect(matching).to yield_with_args(ln, 'Explicit div') }
      end

      context 'slim' do
        let(:extension) { 'slim' }
        let(:line) { 'div.abc' }

        it { expect(matching).to yield_with_args(ln, 'Explicit div') }
      end

      context 'otherwise' do
        let(:extension) { 'erb' }
        let(:line) { "<div class='abc'>" }

        it { expect(matching).not_to yield_control }
      end
    end

    context 'old hash syntax' do
      let(:line) { ':a => 1' }

      context 'rb' do
        let(:extension) { 'rb' }

        it { expect(matching).to yield_with_args(ln, 'Old hash syntax') }
      end

      context 'otherwise' do
        it { expect(matching).not_to yield_control }
      end
    end

    context 'filter' do
      let(:line) { 'before_filter :set_args' }

      context 'rb' do
        let(:extension) { 'rb' }

        it { expect(matching).to yield_with_args(ln, 'Use action') }
      end

      context 'otherwise' do
        it { expect(matching).not_to yield_control }
      end
    end

    context 'use where and count to check for exists' do
      let(:line) { 'where(attr: "attr").count > 0' }

      context 'rb' do
        let(:extension) { 'rb' }

        it { expect(matching).to yield_with_args(ln, 'Check exists') }
      end

      context 'otherwise' do
        it { expect(matching).not_to yield_control }
      end
    end

    context 'use render partial in view' do
      let(:line) { '= render partial: "view"' }

      %w(erb haml slim).each do |lang|
        context lang do
          let(:extension) { lang }

          it { expect(matching).to yield_with_args(ln, 'Partial redundancy') }
        end
      end

      context 'otherwise' do
        it { expect(matching).not_to yield_control }
      end
    end

    context 'use render locals in view' do
      let(:line) { '= render "view", locals: { abc: 123 }' }

      %w(erb haml slim).each do |lang|
        context lang do
          let(:extension) { lang }

          it { expect(matching).to yield_with_args(ln, 'Locals redundancy') }
        end
      end

      context 'otherwise' do
        it { expect(matching).not_to yield_control }
      end
    end
  end
end
