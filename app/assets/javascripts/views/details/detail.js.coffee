@DetailView = Backbone.View.extend
  #tag: 'div'
  el: '#item-details-pane'
  #template: 'details/detail'

  initialize: () ->
    _.bindAll(this, 'render', 'renderVoteGraph', 'hide', 'show', 'isVisible', 'scroll')
    this.model.bind('change', this.render)
    OurvoyceApp.items.bind('show_details', this.show)
    OurvoyceApp.items.bind('hide_details', this.hide)
    $(window).scroll(this.scroll)
    return

  render: () ->
    this.displaying_item_id = this.model.get('id')


    $(this.el).find('#item-detail-name').html(this.model.get('name'))

    try
      window.sendToMap(this.model.get('id'))
      window.sendToGraph(this.model.get('id'), '')
    catch error

    this.renderVoteGraph()

    this.model.set({displayed: true})

    return this

  isVisible: () ->
    return $(this.el).is(':visible')

  renderVoteGraph: () ->
    thumbs_up_vote_count = 0
    neutral_vote_count = 0
    thumbs_down_vote_count = 0

    thumbs_up_vote_count = this.model.get('thumbs_up_vote_count')
    neutral_vote_count = this.model.get('neutral_vote_count')
    thumbs_down_vote_count = this.model.get('thumbs_down_vote_count')

    max_height = Math.max(thumbs_up_vote_count, thumbs_down_vote_count, neutral_vote_count, 1)

    #TODO: Determine actual height by examining html
    container_height = 50

    thumbs_up_element = $(this.el).find('.vote-chart .thumbs-up .height')
    neutral_element = $(this.el).find('.vote-chart .neutral .height')
    thumbs_down_element = $(this.el).find('.vote-chart .thumbs-down .height')

    $(this.el).find('.thumbs-up .votenumber').html(thumbs_up_vote_count)
    $(this.el).find('.neutral .votenumber').html(neutral_vote_count)
    $(this.el).find('.thumbs-down .votenumber').html(thumbs_down_vote_count)

    thumbs_up_element.animate
      height: Math.ceil(container_height * thumbs_up_vote_count / max_height) + "px"
    neutral_element.animate
      height: Math.ceil(container_height * neutral_vote_count / max_height) + "px"
    thumbs_down_element.animate
      height: Math.ceil(container_height * thumbs_down_vote_count / max_height) + "px"
    return


  hide: () ->
    if this.isVisible()
      $(this.el).hide('slide', {direction: 'left'}, 500)
    return this

  show: () ->
    if !this.isVisible()
      $(this.el).show('slide', {direction: 'left'}, 500)
    return this


  setPosition: () ->
    return
    items = $("#items")
    filter = $("#filter_box")
    details = $("#details")
    content_top = items.offset().top
    window_top = $(window).scrollTop()
    window_left = $(window).scrollLeft()
    filter_height = parseInt(filter.css("height").replace(/px/, ''))
    filter_bottom = filter.offset().top + filter_height

    #if(window_top > content_top)
    if(filter_bottom > content_top)
      details.addClass("fixed")
      left = items.offset().left + items.outerWidth() - window_left
      #details.css("position", "fixed")
      #margin_top = parseInt($("#items").css('margin-top').replace(/px/, ''))
      #details.css("top", "#{filter_height + margin_top}px")
      details.css("left", "#{left}px")
    else
      #details.css("position", "absolute")
      #details.css("top", "0px")
      details.css("left", "")
      details.removeClass("fixed")



  scroll: () ->
    this.setPosition()
    return
