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
        $this.siblings('.comments').append(data)
