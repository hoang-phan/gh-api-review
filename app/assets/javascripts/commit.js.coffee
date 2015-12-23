snippets = {}
randomComments = {}

textcompleteOptions = [
  match: /\b(\w+)$/
  index: 1
  search: (term, callback) ->
    callback($.map(snippets, (value, key) ->
      if matchString(key, term) then key else null
    ))
  replace: (word) ->
    "#{snippets[word]}".split('[[cursor]]')
]

matchString = (str, term) ->
  regex = ''
  for ch in term
    regex += "#{ch}.*"
  str.match(regex)

sample = (items) ->
  items[Math.floor(Math.random() * items.length)]

removeItem = (items, matches, value) ->
  items.filter (val) ->
    replaceTemplate(val, matches) != value

fetchSnippets = ->
  $.ajax
    url: '/snippets'
    dataType: 'json'
    success: (data) ->
      snippets = data.snippets

fetchRandomComments = ->
  $.ajax
    url: '/commits_suggestions'
    dataType: 'json'
    success: (data) ->
      randomComments = data.comments

replaceTemplate = (text, matches) ->
  result = text
  matches.split('<,>').forEach (value, index) ->
    result = result.replace(new RegExp("<#{index}>", 'g'), value)
  result

$ ->
  fetchSnippets()
  fetchRandomComments()

  $fileChangeContent = $('.file-change-content')
  $fileChangeContent.find('textarea[name=body]').textcomplete(textcompleteOptions)

  $fileChangeContent.on 'keydown', 'textarea[name=body]', (e) ->
    if (e.keyCode || e.which) == 9
      e.preventDefault()
      caretPos = $(this)[0].selectionStart
      val = $(this).val()
      $(this).val("#{val.substring(0, caretPos)}  #{val.substring(caretPos)}")
      $(this)[0].selectionStart = $(this)[0].selectionEnd = caretPos + 2

  $fileChangeContent.find('[name=rules]').trigger('change')

  $fileChangeContent.on 'change', '[name=rules]', (e) ->
    $this = $(this)
    $rule = $this.find('option:selected')
    text = sample(randomComments[$rule.text()])
    $this.closest('form').find('[name=body]').val(replaceTemplate(text, $rule.val()))
    false

  $fileChangeContent.on 'click', '.cancel-btn', ->
    $(this).closest('.comment-form').remove()
    false

  $fileChangeContent.on 'click', '.random-comment', ->
    $this = $(this)
    $body = $this.closest('form').find('[name=body]')
    $rule = $this.siblings("[name=rules]").find("option:selected")
    comments = randomComments[$rule.text()]
    comments = removeItem(comments, $rule.val(), $body.val())
    if comments.length > 0
      text = sample(comments)
      $body.val(replaceTemplate(text, $rule.val()))
    false

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
        $textarea.textcomplete(textcompleteOptions)


