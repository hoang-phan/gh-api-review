module CommitHelper
  def display_comments(line_comments, filename, line, is_modified, klass)
    if show_comment?(is_modified, klass) && (comments = line_comments[filename].try(:[], line)).present?
      render 'file_changes/comments', comments: comments
    end
  end

  def display_line_change(key, value, special_class)
    content_tag :p do
    content_tag(:span, key.rjust(4), class: 'line-number') + content_tag(:span, value[0].presence || ' ', class: line_class(value[2], special_class))
    end
  end

  def line_class(is_special, special_class)
    "line #{is_special ? special_class : 'unchanged-line'}"
  end

  def show_comment?(is_modified, special_class)
    is_modified || special_class == 'added-line'
  end

  def render_line_changes(line_changes, klass, filename, suggestions = {})
    suggestions ||= {}
    line_changes.map do |key, value|
      line_suggestions = suggestions[key].to_a.map do |suggestion|
        [ suggestion['name'], suggestion['matches'].join('<,>') ]
      end
      render 'file_changes/line_change', key: key, value: value, special_class: klass, filename: filename, line_suggestions: line_suggestions
    end.join('')
  end

  def random_comments(suggestion)
    matches = suggestion[1].split('<,>')
    template = RANDOM_COMMENTS[suggestion[0]].sample
    suggestion[1].split('<,>').each_with_index do |match, index|
      template = template.gsub("<#{index}>", match)
    end
    template
  end
end
