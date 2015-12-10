$checkBoxes = $('[type=checkbox]')
$checkBoxes.bootstrapSwitch()

$checkBoxes.on 'switchChange.bootstrapSwitch', (e) ->
  $(this).closest('form').submit()

$('.file-change-content').on 'click', 'p', ->
  $this = $(this)
  $.ajax
    url: '/comments/new'
    method: 'get'
    success: (data) ->
      $this.append(data)
      false
  false
false
