$ ->
  $('#how-does-this-work .answer').hide()

  $('#how-does-this-work h3.question').click( (e) ->
    $(this).next('.answer').toggle('fast')
    return
  )
