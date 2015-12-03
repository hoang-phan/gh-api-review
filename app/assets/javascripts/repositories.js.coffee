$ ->
  $checkBoxes = $("[name='enable_hook']")
  $checkBoxes.bootstrapSwitch()

  $checkBoxes.on 'switchChange.bootstrapSwitch', (e) ->
    $el = $(this)
    id = $el.closest('.bootstrap-switch').siblings('#repo_id').val()

    if $el.is(":checked")
      $.ajax
        url: "/hooks/#{id}"
        method: "PUT"
        success: (response)->
          console.log(response)
        error: (response) ->
          console.log(response)
    else
      $.ajax
        url: "/hooks/#{id}"
        method: "DELETE"
        success: (response)->
          console.log(response)
        error: (response) ->
          console.log(response)
    false
  false