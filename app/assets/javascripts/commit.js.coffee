matchString = (str, term) ->
  regex = ''
  for ch in term
    regex += "#{ch}.*"
  str.match(regex)

$ ->
  $fileChangeContent = $('.file-change-content')

  snippets = {}

  $.ajax
    url: '/snippets'
    dataType: 'json'
    success: (data) ->
      snippets = data.snippets

  $fileChangeContent.find('p').on 'click', ->
    $this = $(this)
    $comments = $this.siblings('.comments')
    return if $comments.find('.comment-form').length > 0
    $.ajax
      url: '/comments/new'
      method: 'get'
      data:
        line: $this.closest('.line-change').data('line')
        filename: $this.closest('.file-change').find('.file-change-header').text()
        commit_id: location.pathname.split('/').pop()

      success: (data) ->
        $comments.append(data)
        $textarea = $comments.find('[name=body]')
        $textarea.focus()
        $textarea.on 'keydown', (e) ->
          keyCode = e.keyCode || e.which
          if keyCode == 9
            e.preventDefault()
            caretPos = $(this)[0].selectionStart
            val = $(this).val()
            $(this).val("#{val.substring(0, caretPos)}  #{val.substring(caretPos)}")
            $(this)[0].selectionStart = $(this)[0].selectionEnd = caretPos + 2

        $textarea.textcomplete [
          match: /\b(\w+)$/
          search: (term, callback) ->
            callback($.map(snippets, (value, key) ->
              if matchString(key, term) then key else null
            ))
          index: 1
          replace: (word) ->
            "#{snippets[word]}".split('[[cursor]]')
        ]

        $comments.find('.cancel-btn').on 'click', (e) ->
          $comments.find('.comment-form').remove()
          false


