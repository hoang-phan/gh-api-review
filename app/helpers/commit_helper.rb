module CommitHelper
  def display_line_change(line_changes, special_class)
    line_changes.map do |key, value|
      content_tag :p do
        content_tag(:span, key.rjust(5), class: 'line-number') + content_tag(:span, value[0], class: line_class(value[1], special_class))
      end
    end.join('')
  end

  def line_class(is_special, special_class)
    "line #{is_special ? special_class : 'unchanged-line'}"
  end
end
