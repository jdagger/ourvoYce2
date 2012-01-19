$ ->
  $('#tag-lookup').autocomplete
    autoFocus: true
    minLength: 2
    delay: 200
    source: (request, response) ->
      csrfName = $("meta[name='csrf-param']").attr('content')
      csrfVal = $("meta[name='csrf-token']").attr('content')
      postData = {name: request.term }
      postData[csrfName] = csrfVal
      $.ajax
        url: "/admin/tags/lookup_by_name"
        dataType: 'json'
        data: postData
        success: (data) ->
          response $.map(data, (tag) =>
            return {label: tag.name, value: tag.id}
          )
          return
      return
    select: (event, ui) ->
      window.location = "/admin/tags/#{ui.item.value}/edit"
      return
    change: (event, ui) ->
      console.log 'change'
      return
  return
