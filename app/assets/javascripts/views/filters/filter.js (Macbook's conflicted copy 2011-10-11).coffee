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
    #this.collection.bind('all', this.render)
    $(window).scroll(this.scroll)
    return

  update_sort: () ->
    keyword = OurvoyceApp.items.keyword
    filter = OurvoyceApp.items.filter

    sort = "#{$(this.el).find("#sort").val()}:#{$(this.el).find("#sort_direction").val()}"
    console.log sort
    KeywordNavigate(keyword, filter, sort)

    return

  update_filter: () ->
    keyword = OurvoyceApp.items.keyword
    sort = OurvoyceApp.items.sort_details
    filter = $(this.el).find("#filter").val()

    console.log filter
    console.log keyword
    console.log sort

    KeywordNavigate(keyword, filter, sort)

    return

  render: () ->
    $(this.el).html($.tmpl(this.template))
    return this

  scroll: () ->
    window_top = $(window).scrollTop()
    content_top = $("#content_container").offset().top
    if(window_top > content_top)
      $("#filter_box").addClass("fixed")
    else
      $("#filter_box").removeClass("fixed")
    return
