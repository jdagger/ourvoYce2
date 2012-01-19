@FilterView = Backbone.View.extend
  tag: 'div'
  el: '#filter_container'
  template: 'filters/filter'

  events: 
    "change #sort": "update_sort"
    "change #sort_direction": "update_sort"
    "change #filter": "update_filter"

  initialize: () ->
    this.render()
    OurvoyceApp.items.bind('reset', this.items_reset)
    return

  items_reset: () ->
    
    if OurvoyceApp.items.friendly_name == 'Item'
      $('#filter_fields').hide();
    else
      $('#filter_fields').show();
    return

  update_sort: () ->
    tag = OurvoyceApp.items.tag
    filter = OurvoyceApp.items.filter
    base_url = OurvoyceApp.items.base_url

    sort_name = $(this.el).find("#sort").val()
    sort_direction = $(this.el).find("#sort_direction").val()
    Navigate(base_url, tag, filter, sort_name, sort_direction)

    return

  update_filter: () ->
    tag = OurvoyceApp.items.tag
    sort_name = OurvoyceApp.items.sort_name
    sort_direction = OurvoyceApp.items.sort_direction
    base_url = OurvoyceApp.items.base_url
    filter = $(this.el).find("#filter").val()

    Navigate(base_url, tag, filter, sort_name, sort_direction)

    return

  render: () ->
    $(this.el).html(JST[this.template]({filter: OurvoyceApp.items.filter, sort_name: OurvoyceApp.items.sort_name, sort_direction: OurvoyceApp.items.sort_direction}))
    this.setup_autocomplete()
    #$(this.el).find('#tag_search').submit(this.search)
    return this

  setup_autocomplete: () ->
    _highlight = this.highlight
    $(this.el).find("#search_field").autocomplete
      autofocus: true
      minLength: 2
      delay: 200
      source: (request, response) ->
        $.ajax
          url: "/search/autocomplete"
          dataType: 'json'
          data: {term: request.term}
          success: (data) ->
            response $.map(data, (item) =>
              return {label: _highlight(item.friendly_name, request.term), value: item.friendly_name}
            )
            return
        return
      select: (event, ui) ->
        $('#search_field').val(ui.item.value)
        $('#tag_search').submit()
        return
      change: (event, ui) ->
        return
    $(this.el).find("#search_field").data('autocomplete')._renderItem = (ul, item) ->
      #only change here was to replace .text() with .html()
      return $( "<li></li>" ).data( "item.autocomplete", item ).append( $( "<a></a>" ).html(item.label) ).appendTo( ul )
    return

  highlight: (s, t) ->
    matcher = new RegExp("("+$.ui.autocomplete.escapeRegex(t)+")", "ig" )
    return s.replace(matcher, "<strong>$1</strong>")
