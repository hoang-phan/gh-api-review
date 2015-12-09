module PatchHelper
  class << self
    include ActionView::Helpers::TagHelper

    def modified_patch(patch)
      return '' unless patch
      s1 = s2 = 0
      patch.split("\n").inject('') do |displayed, line|
        code_line = if (parts = line.match(/^@@ -(\d+),(\d+) \+(\d+),(\d+) @@(.*)$/))
          s2, e2, s1, e1 = parts[1..4].map(&:to_i)
          displayed += "\n..."
          parts[5]
        else
          line
        end

        adding = display_full_line(s2, s1, code_line)

        s1 += 1 if code_line[0] != '-'
        s2 += 1 if code_line[0] != '+'

        displayed + adding
      end
    end

    def display_line(line)
      content_tag :span, line, class: display_class(line[0])
    end

    def display_class(character)
      case character
      when '+' then 'added-line'
      when '-' then 'removed-line'
      else
        'unchanged-line'
      end
    end

    def displayed_base_ln(ln, character)
      display_ln(ln, character == '+')
    end

    def displayed_changed_ln(ln, character)
      display_ln(ln, character == '-')
    end

    def display_ln(ln, hide_ln)
      ln = '' if hide_ln
      content_tag :span, ln.to_s.rjust(5, ' ')
    end

    def display_full_line(base_ln, changed_ln, line)
      "\n#{displayed_base_ln(base_ln, line[0])} | #{displayed_changed_ln(changed_ln, line[0])} | #{display_line(line)}"
    end
  end
end