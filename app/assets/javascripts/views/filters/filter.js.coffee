@FilterView = Backbone.View.extend
  tag: 'div'
  el: '#filter_container'
  template: 'filters/filter'

  events: 
    "change #sort > select": "update_filter"
    "change #sort_direction > select": "update_filter"
    "change #filter > select": "update_filter"


  initialize: () ->
    _.bindAll(this, 'render', 'scroll')
    #this.collection.bind('all', this.render)
    $(window).scroll(this.scroll)
    return

  update_filter: () ->
    console.log "UPDATE_FILTER: " + window.OurvoyceApp.current_keyword.get('path');
    OurvoyceApp.router.navigate('k/' + this.model.get('_id'), true)
    return

  render: () ->
    #records_loaded = this.collection.length
    #total_records = OurvoyceApp.item_ids.length

    #if records_loaded >= total_records
    #$(this.el).html("all records loaded")
    #else
    #$(this.el).html("(#{records_loaded} / #{total_records})")
    #$(this.el).html($.tmpl(this.template, this.model.toJSON()))
    $(this.el).html($.tmpl(this.template))
    return this

  scroll: () ->
    window_top = $(window).scrollTop()
    content_top = $("#content_container").offset().top
    if(window_top > content_top)
      $("#filter_box").addClass("fixed")
      #$(this.el).css("position", "fixed")
      #$(this.el).css("top", "0px")
    else
      $("#filter_box").removeClass("fixed")
      #$(this.el).css("position", "relative")
      #$(this.el).css("top", "")
    return
