module PatchHelper
  class << self
    include ActionView::Helpers::TagHelper

    def build_patch(patch)
      return {} unless patch
      s1 = s2 = 0
      result = { '+' => {}, '-' => {} }

      patch.split("\n").each do |line|
        code_line = if (parts = line.match(/^@@ -(\d+),(\d+) \+(\d+),(\d+) @@(.*)$/))
          s2, e2, s1, e1 = parts[1..4].map(&:to_i)
          parts[5]
        else
          line
        end
        if code_line[0] == '+'
          result['+'][s1] = [code_line, true]
          s1 += 1
        elsif code_line[0] == '-'
          result['-'][s2] = [code_line, true]
          s2 += 1
        else
          result['+'][s1] = [code_line]
          result['-'][s2] = [code_line]
          s1 += 1
          s2 += 1
        end
      end
      result
    end
  end
end
