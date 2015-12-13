module CommitHelper
  def display_line_change(key, value, special_class)
    content_tag :p do
      content_tag(:span, key.rjust(5), class: 'line-number') + content_tag(:span, value[0], class: line_class(value[2], special_class))
    end
  end

  def line_class(is_special, special_class)
    "line #{is_special ? special_class : 'unchanged-line'}"
  end
end
