@DetailView = Backbone.View.extend
  el: '#item-details-pane'

  initialize: () ->
    _.bindAll(this, 'render', 'renderVoteGraph', 'renderMap', 'renderAgeGraph', 'showDetails', 'hideDetails')

    #this.animateSpeed = 200

    this.model.bind('newDetails', this.render)
    this.model.bind('showDetails', this.showDetails)
    this.model.bind('hideDetails', this.hideDetails)

    $(window).scroll(this.scroll)
    return

  events:
    "click #hide-details": "hideDetailsClick"

  #Event handler for showDetails
  showDetails: (item) ->
    $(this.el).find('#map').css('visibility', 'visible')
    $(this.el).find('#bar-graph').css('visibility', 'visible')
    $(this.el).css('visibility', 'visible')
    return this

  #Event handler for hideDetails
  hideDetails: () ->
    $(this.el).find('#map').css('visibility', 'hidden')
    $(this.el).find('#bar-graph').css('visibility', 'hidden')
    $(this.el).css('visibility', 'hidden')
    return this

  #Click the hide details button on details pane
  hideDetailsClick: (e) ->
    e.preventDefault()
    OurvoyceApp.detail.hideDetails()
    return
  

  render: () ->
    $(this.el).find('#item-detail-name').html(this.model.name())
    $(this.el).find('#item-detail-website').attr('href', this.model.website())
    $(this.el).find('#item-detail-wikipedia').attr('href', this.model.wikipedia())
    this.renderVoteGraph()
    this.renderMap()
    this.renderAgeGraph()

    return this

  renderVoteGraph: () ->
    thumbs_up_vote_count = 0
    neutral_vote_count = 0
    thumbs_down_vote_count = 0

    thumbs_up_vote_count = this.model.thumbsUpVoteCount()
    neutral_vote_count = this.model.neutralVoteCount()
    thumbs_down_vote_count = this.model.thumbsDownVoteCount()

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

  renderMap: () ->
    try
      window.sendToMap(this.model.id())
    catch error
      console.log "Map Error:  #{error}"
    return

  renderAgeGraph: () ->
    try
      window.sendToGraph(this.model.id(), '')
    catch error
      console.log "Graph Error: #{error}"
    return

  #
  #  setPosition: () ->
  #    return
  #    items = $("#items")
  #    filter = $("#filter_box")
  #    details = $("#details")
  #    content_top = items.offset().top
  #    window_top = $(window).scrollTop()
  #    window_left = $(window).scrollLeft()
  #    filter_height = parseInt(filter.css("height").replace(/px/, ''))
  #    filter_bottom = filter.offset().top + filter_height
  #
  #    #if(window_top > content_top)
  #    if(filter_bottom > content_top)
  #      details.addClass("fixed")
  #      left = items.offset().left + items.outerWidth() - window_left
  #      #details.css("position", "fixed")
  #      #margin_top = parseInt($("#items").css('margin-top').replace(/px/, ''))
  #      #details.css("top", "#{filter_height + margin_top}px")
  #      details.css("left", "#{left}px")
  #    else
  #      #details.css("position", "absolute")
  #      #details.css("top", "0px")
  #      details.css("left", "")
  #      details.removeClass("fixed")
  #
  #

  #scroll: () ->
  #this.setPosition()
  #return
