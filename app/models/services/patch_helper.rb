module PatchHelper
  class << self
    include ActionView::Helpers::TagHelper

    def build_patch(patch)
      return {} unless patch
      s1 = s2 = 0
      result = { '+' => {}, '-' => {} }

      patch.split("\n").each_with_index do |line, index|
        code_line = if (parts = line.match(/^@@ -(\d+),(\d+) \+(\d+),(\d+) @@(.*)$/))
          s2, e2, s1, e1 = parts[1..4].map(&:to_i)
          parts[5]
        else
          line
        end

        if code_line[0] == '+'
          result['+'][s1] = [code_line, index,true]
          s1 += 1
        elsif code_line[0] == '-'
          result['-'][s2] = [code_line, index, true]
          s2 += 1
        else
          result['+'][s1] = [code_line, index]
          result['-'][s2] = [code_line, index]
          s1 += 1
          s2 += 1
        end
      end
      result
    end
  end
end
