@FilterView = Backbone.View.extend
  tag: 'div'
  el: '#filter_container'
  template: 'filters/filter'

  events: 
    "change #sort": "update_sort"
    "change #sort_direction": "update_sort"
    "change #filter": "update_filter"



  initialize: () ->
    _.bindAll(this, 'render', 'scroll')
    $(window).scroll(this.scroll)
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
    $(this.el).html($.tmpl(this.template, {filter: OurvoyceApp.items.filter, sort_name: OurvoyceApp.items.sort_name, sort_direction: OurvoyceApp.items.sort_direction}))
    this.setup_autocomplete()
    #$(this.el).find('#tag_search').submit(this.search)
    return this

  #search: () ->
  #return true

  setup_autocomplete: () ->
    _highlight = this.highlight
    $(this.el).find("#search_field").autocomplete
      minLength: 1
      delay: 200
      source: (request, response) ->
        $.ajax
          url: "/search/autocomplete"
          dataType: 'json'
          data: {term: request.term}
          success: (data) ->
            response $.map(data, (item) =>
              return {label: _highlight(item.label, request.term), value: item.value}
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
  scroll: () ->
    window_top = $(window).scrollTop()
    content_top = $("#content_container").offset().top
    if(window_top > content_top)
      $("#filter_box").addClass("fixed")
    else
      $("#filter_box").removeClass("fixed")
    return
