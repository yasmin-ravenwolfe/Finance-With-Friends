$ ->
  receiptListItem = $('.receipt-list-item')

  receiptListItem.click -> 
    # id = $(@).attr('id')
    # receiptItems = $("#list-items-#{id}")
    # console.log receiptItems
    # $(@).append(receiptItems.show())
    $(@).siblings().toggle()

