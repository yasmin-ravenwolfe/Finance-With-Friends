$ ->
  receiptListItem = $('.receipt-list-item')

  receiptListItem.click ->
    $(@).parent().find('ul').toggle()

  $('#split-link').click ->
    $(@).parent.find('span').show()


