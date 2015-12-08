module CommitHelper
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
end
