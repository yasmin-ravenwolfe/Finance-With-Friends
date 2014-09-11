$ ->

  purchaseForm = $('#purchase_form')
  splitCheckbox = $('#split-checkbox')
  # On page load (and redirected when there are form errors) checkbox is unchecked.
  splitCheckbox.attr('checked', false)

  splitCheckbox.click ->
    $('.one-buyer-fields').toggle()
    $('.split-fields').toggle()

  $.guard(".required").using("required");
  $.guard('#quantity-field').using('float')
  $.guard('#price-field').using('float')
  $.guard('.split-fields.percentages').using('float', {min: 0, max: 100})
  $.guard('#tax-field').using('float', {min: 0, max: 100})
  $.enableGuards(purchaseForm)

  $.guards.name('percentage').grouped().message('Percentage total must add up to 100%.').using (values, elements) ->
    total = 0.0
    for value in values
      value = 0 if value == ""
      total += parseFloat(value)
    total >= 99.89 && total <= 100.0

  $.guards.name('buyer').grouped().message('Buyer selected more than once.').using (values, elements) ->
    people = []
    for value in values
      if value != '0'
        alert 'not 0'
        people.push(value)
    sortDescending(people.unique()).toString() == sortDescending(people).toString()

  $.guard('.split-fields.percentages').using('percentage')
  $.guard('.split-fields.memberships').using('buyer')
  $.enableGuards(purchaseForm)


  Array::unique = ->
      output = {}
      output[@[key]] = @[key] for key in [0...@length]
      value for key, value of output

  sortDescending = (array) ->
    array.sort (a,b) ->
      return a-b
