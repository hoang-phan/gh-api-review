module CommitHelper
  def display_comment(line_comments, filename, line, is_modified, klass)
    if show_comment?(is_modified, klass) && (comment = line_comments[filename].try(:[], line))
      render 'file_changes/comment', comment: comment
    end
  end

  def display_line_change(key, value, special_class)
    content_tag :p do
      content_tag(:span, key.rjust(5), class: 'line-number') + content_tag(:span, value[0], class: line_class(value[2], special_class))
    end
  end

  def line_class(is_special, special_class)
    "line #{is_special ? special_class : 'unchanged-line'}"
  end

  def show_comment?(is_modified, special_class)
    is_modified || special_class == 'added-line'
  end

  def render_line_changes(line_changes, klass, filename)
    line_changes.map do |key, value|
      render 'file_changes/line_change', key: key, value: value, special_class: klass, filename: filename
    end.join('')
  end
end
