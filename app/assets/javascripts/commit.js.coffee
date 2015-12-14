$ ->
  $fileChangeContent = $('.file-change-content')
  $fileChangeContent.find('p').on 'click', ->
    $this = $(this)
    $.ajax
      url: '/comments/new'
      method: 'get'
      data:
        line: $this.closest('.line-change').data('line')
        filename: $this.closest('.file-change').find('.file-change-header').text()
        commit_id: location.pathname.split('/').pop()

      success: (data) ->
        $comments = $this.siblings('.comments')
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


