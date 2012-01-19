$ ->
  $('#item-lookup').autocomplete
    autoFocus: true
    minLength: 2
    delay: 200
    source: (request, response) ->
      csrfName = $("meta[name='csrf-param']").attr('content')
      csrfVal = $("meta[name='csrf-token']").attr('content')
      postData = {name: request.term }
      postData[csrfName] = csrfVal
      $.ajax
        url: "/admin/items/lookup_by_name"
        dataType: 'json'
        data: postData
        success: (data) ->
          response $.map(data, (item) =>
            return {label: item.name, value: item.id}
          )
          return
      return
    select: (event, ui) ->
      window.location = "/admin/items/#{ui.item.value}/edit"
      return
    change: (event, ui) ->
      console.log 'change'
      return
  return
