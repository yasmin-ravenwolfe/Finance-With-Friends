$ ->
  # On page load (and redirected when there are form errors) checkbox is unchecked.
  $('#split-checkbox').attr('checked', false)

  $('#split-checkbox').click ->
    $(".one-buyer-fields").toggle()
    $(".split-fields").toggle()


