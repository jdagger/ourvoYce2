@DetailView = Backbone.View.extend
  el: '#item-details-pane'

  initialize: () ->
    _.bindAll(this, 'render', 'renderVoteGraph', 'filterInviewChange', 'resizeDetailsPane', 'positionDetailsPane', 'resize', 'renderMap', 'renderAgeGraph', 'showDetails', 'hideDetails', 'refreshMapClick')

    #this.animateSpeed = 200

    this.model.bind('newDetails', this.render)
    this.model.bind('showDetails', this.showDetails)
    this.model.bind('hideDetails', this.hideDetails)
    this.model.bind('vote_changed', this.renderVoteGraph)

    $(window).resize(this.resize)

    $('#filter_container').bind('inview', this.filterInviewChange)

    this.resizeDetailsPane()

    return

  events:
    "click #hide-details": "hideDetailsClick"
    "click #refresh-map": "refreshMapClick"

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

  refreshMapClick: (e) ->
    e.preventDefault()
    this.renderMap()
    this.renderAgeGraph()
    return

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
      #console.log "Map Error:  #{error}"
    return

  renderAgeGraph: () ->
    try
      window.sendToGraph(this.model.id(), '')
    catch error
      #console.log "Graph Error: #{error}"
    return


  positionDetailsPane: () ->
    filter_inview = $('#filter_container').data('inview')

    if filter_inview
      $(this.el).css('left', '')
      $(this.el).css('top', '')
      $(this.el).removeClass("details-pane-fixed").addClass('details-pane-absolute')
    else
      items_container = $("#items")
      window_left = $(window).scrollLeft()
      #left =  items_container.offset().left + items_container.outerWidth() - window_left - 5
      left =  items_container.offset().left + items_container.outerWidth() - window_left
      #TODO - Determine where the 5px left and 4px top fudges are coming from
      
      $(this.el).css('left', "#{left}px")
      #$(this.el).css('top', "4px")
      $(this.el).addClass("details-pane-fixed").removeClass('details-pane-absolute')
    return

  resizeDetailsPane: () ->
    $(this.el).height($(window).height() - 8)
    return


  #Determines if the filter box is in view
  #If filter box is in view, display details pane regularly
  #Otherwise, set as fixed position
  filterInviewChange: (e, inview) ->
    this.positionDetailsPane()
    return

  resize: () ->
    this.resizeDetailsPane()
    this.positionDetailsPane()
    return
