$ ->
  $checkBoxes = $('[type=checkbox]')
  $checkBoxes.bootstrapSwitch()

  $checkBoxes.on 'switchChange.bootstrapSwitch', (e) ->
    $(this).closest('form').submit()
    