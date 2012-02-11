$ ->
  $('.autocomplete-type').on('click', (e) ->
    e.preventDefault()
    switch $(this).text()
      when "Items"
        $("#autocomplete_url").val("/admin/items/suggest_by_name")
        $("#autocomplete_form").attr('action', "/admin/items/find_by_autocomplete")
        $("#item-lookup").attr('placeholder', "Find Items")
      when "Tags"
        $("#autocomplete_url").val("/admin/tags/suggest_by_name")
        $("#autocomplete_form").attr('action', "/admin/tags/find_by_autocomplete")
        $("#item-lookup").attr('placeholder', "Find Tags")
      
    return
  )

  $('#item-lookup').typeahead
    source: (obj, success_callback) ->
      $.ajax
        url: $('#autocomplete_url').val(),
        dataType: 'json',
        data: {name: obj.query},
        success: (data) ->
          items = $.map(data, (item) ->
            return "#{item.name} (#{item.id})"
          )

          success_callback(obj, items)
  return
