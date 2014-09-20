$ ->
  purchaseForm = $('#purchase-form')
  splitCheckbox = $('#split-checkbox')
  oneBuyerFields = $('.one-buyer-fields')
  splitFields = $('.split-fields')
  splitFieldsPercentages = $('.split-fields.percentages')
  splitErrors = $('.split-errors')
  submitForm = $('input[name=commit]')
  # On page load (and redirected when there are form errors) checkbox is unchecked. (Or calling click to show/hide fields will change checked status).
  splitCheckbox.attr('checked', false)
  # On page load
  oneBuyerGuardsOn = true

  toggleFields = () ->
    oneBuyerFields.toggle()
    splitFields.toggle()

  splitCheckbox.click () ->
    toggleFields()

  if splitFieldsPercentages.val() || splitErrors.text() != ""
    splitCheckbox.click()

  submitForm.click ->
    if oneBuyerFields.css('display') == 'none'
      oneBuyerGuardsOn = false
      guardForm()
    else
      oneBuyerGuardsOn = true
      guardForm()

  guardForm = () ->
    $.guard(".required").using('required');
    $.guard('#quantity-field').using('float')
    $.guard('#price-field').using('float')
    $.guard('#tax-field').using('float', {min: 0, max: 100})

    if oneBuyerGuardsOn == true
      $.guard('.one-buyer-fields').using('required')
    else if $('.one-buyer-fields').css('display') == 'none'
      $.guard('.split-fields.percentages').using('float', {min: 0, max: 100})

      $.guards.name('percentage').grouped().message('Percentage total must add up to 100%.').using (values, elements) ->
        total = 0.0
        for value in values
          value = 0 if value == ""
          total += parseFloat(value)
        total >= 99.89 && total <= 100.0

      $.guards.name('buyer').grouped().message('Buyer selected more than once.').using (values, elements) ->
        people = []
        for value in values
          if value != ""
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
