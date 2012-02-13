$ ->
  $('.autocomplete-type').on('click', (e) ->
    e.preventDefault()
    $this = $(this)
    $('.btn-group > button').removeClass('active')
    $this.addClass('active')

    search_type = $this.attr('data-search')

    $("#autocomplete_url").val("/admin/#{search_type.toLowerCase()}/suggest_by_name")
    $("#autocomplete_form").attr('action', "/admin/#{search_type.toLowerCase()}/find_by_autocomplete")
    $("#item-lookup").attr('placeholder', "Find #{search_type}")
      
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
