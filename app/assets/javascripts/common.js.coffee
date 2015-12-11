$ ->
  $checkBoxes = $('[type=checkbox]')
  $fileChangeContent = $('.file-change-content')
  $checkBoxes.bootstrapSwitch()

  $checkBoxes.on 'switchChange.bootstrapSwitch', (e) ->
    $(this).closest('form').submit()

  $fileChangeContent.find('p').on 'click', ->
    $this = $(this)
    $.ajax
      url: '/comments/new'
      method: 'get'
      data:
        line: $this.data('line')
        filename: $this.closest('.file-change').find('.file-change-header').text()
        commit_id: location.pathname.split('/').pop()

      success: (data) ->
        $(data).insertAfter($this)
  $fileChangeContent.find('form').on 'submit', ->
    console.log('a')
    $(this).find('input[type=submit]').attr('disabled', 'disabled')
    true
