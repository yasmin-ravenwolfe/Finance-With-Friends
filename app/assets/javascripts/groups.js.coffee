$ ->
  $('.delete-member').bind 'ajax:success', (e, data) ->
    $(@).parent('div').remove();


  $('.delete-category').bind 'ajax:success', (e, data) ->
    $(@).parent('div').remove();
