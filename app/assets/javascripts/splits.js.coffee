$ ->
  $("#add-split-button").click ->
    
    $(".new-split-form").each ->
      if $(".new-split-form").attr('style') == "display:none;"
        id = $(@).attr('id')
        $(@).removeClass("new-split-form")
        $(@).show()
        return false
