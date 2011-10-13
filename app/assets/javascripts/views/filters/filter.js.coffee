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
    keyword = OurvoyceApp.items.keyword
    filter = OurvoyceApp.items.filter

    sort_name = $(this.el).find("#sort").val()
    sort_direction = $(this.el).find("#sort_direction").val()
    KeywordNavigate(keyword, filter, sort_name, sort_direction)

    return

  update_filter: () ->
    keyword = OurvoyceApp.items.keyword
    sort_name = OurvoyceApp.items.sort_name
    sort_direction = OurvoyceApp.items.sort_direction
    filter = $(this.el).find("#filter").val()

    KeywordNavigate(keyword, filter, sort_name, sort_direction)

    return

  render: () ->
    $(this.el).html($.tmpl(this.template, {filter: OurvoyceApp.items.filter, sort_name: OurvoyceApp.items.sort_name, sort_direction: OurvoyceApp.items.sort_direction}))
    return this

  scroll: () ->
    window_top = $(window).scrollTop()
    content_top = $("#content_container").offset().top
    if(window_top > content_top)
      $("#filter_box").addClass("fixed")
    else
      $("#filter_box").removeClass("fixed")
    return
