@DetailView = Backbone.View.extend
  el: '#item-details-pane'

  initialize: () ->
    _.bindAll(this, 'render', 'renderVoteGraph', 'filterInviewChange', 'renderFacebookLike', 'renderPlusOne', 'itemsReset', 'itemDetailUrl', 'renderTwitterShare', 'resizeDetailsPane', 'positionDetailsPane', 'resize', 'renderMap', 'renderAgeGraph', 'showDetails', 'hideDetails', 'refreshMapClick')

    this.model.bind('newDetails', this.render)
    this.model.bind('showDetails', this.showDetails)
    this.model.bind('hideDetails', this.hideDetails)
    this.model.bind('vote_changed', this.renderVoteGraph)


    this.slide_speed = 250


    $(window).resize(this.resize)

    OurvoyceApp.items.bind('reset', this.itemsReset)


    $('#filter_container').bind('inview', this.filterInviewChange)
    this.resizeDetailsPane()

    return

  events:
    "click #hide-details": "hideDetailsClick"
    "click #refresh-map": "refreshMapClick"

  slideWidth: () ->
    return $(this.el).css('width')


  itemsReset: () ->
    if (OurvoyceApp.items.friendly_name == 'Item') && (OurvoyceApp.items.length == 1)
      this.model.showDetails(OurvoyceApp.items.at(0))
    return
    

  #Event handler for showDetails
  showDetails: (item) ->
    #Stop any currently running animations
    $(this.el).stop()

    $(this.el).find('#map').css('visibility', 'visible')
    $(this.el).find('#bar-graph').css('visibility', 'visible')
    $(this.el).css('visibility', 'visible')

    #easeOutExpo
    $(this.el).animate({ left: "#{this.paneLeftPosition()}" }, this.slide_speed, 'linear', () ->
      return
    )

    #Begin orig
    #$(this.el).find('#map').css('visibility', 'visible')
    #$(this.el).find('#bar-graph').css('visibility', 'visible')
    #$(this.el).css('visibility', 'visible')
    #End orig
    return this


  #Event handler for hideDetails
  hideDetails: () ->
    #Begin orig
    #$(this.el).find('#map').css('visibility', 'hidden')
    #$(this.el).find('#bar-graph').css('visibility', 'hidden')
    #$(this.el).css('visibility', 'hidden')
    #End orig
    
    left = this.paneLeftPosition().replace(/px/, '') - this.slideWidth().replace(/px/, '')

    #Stop any currently running animations
    $(this.el).stop()
    
    $(this.el).animate({ left: "#{left}px"  }, this.slide_speed, 'linear', () =>
      $(this.el).find('#map').css('visibility', 'hidden')
      $(this.el).find('#bar-graph').css('visibility', 'hidden')
      $(this.el).css('visibility', 'hidden')
      return
    )
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
  
  itemDetailUrl: () ->
    base_url = window.location.href.replace(window.location.hash, '')
    return "#{base_url}#!/item/#{this.model.id()}"

  renderTwitterShare: () ->
    title = "I just voted THUMBS UP / THUMBS DOWN on #{this.model.name()}. Where do you stand?"
    html = JST['social/twitter']({url: encodeURIComponent('http://ourvoyce.com'), title: encodeURIComponent(title) })
    #html = JST['social/twitter']({url: encodeURIComponent(this.itemDetailUrl()), title: encodeURIComponent(title) })
    $(this.el).find('#twitter').html(html)
    return

  renderPlusOne: () ->
    html = JST['social/plusone']({url: this.itemDetailUrl()})
    $(this.el).find('#plusone').html(html)
    gapi.plusone.go()
    return

  renderFacebookLike: () ->
    like_button = "<iframe src=\"//www.facebook.com/plugins/like.php?href=#{encodeURIComponent(this.itemDetailUrl())}&amp;send=false&amp;layout=button_count&amp;width=100&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font&amp;height=21\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:100px; height:21px;\" allowTransparency=\"true\"></iframe>"
    $(this.el).find('#facebook').html(like_button)
    return

  renderCopyLinks: () ->
    $(this.el).find('#copy-item-url').attr('value', this.itemDetailUrl())
    return

  render: () ->
    $(this.el).find('#item-detail-name').html(this.model.name())

    this.renderFacebookLike()
    this.renderPlusOne()
    this.renderTwitterShare()

    this.renderCopyLinks()

    #Hide website link if doesn't contain content
    if this.model.website().length > 0
      $(this.el).find('#item-detail-website').show()
      $(this.el).find('#item-detail-website').attr('href', this.model.website())
    else
      $(this.el).find('#item-detail-website').hide()

    #Hide wikipedia link if doesn't contain content
    if this.model.wikipedia().length > 0
      $(this.el).find('#item-detail-wikipedia').show()
      $(this.el).find('#item-detail-wikipedia').attr('href', this.model.wikipedia())
    else
      $(this.el).find('#item-detail-wikipedia').hide()
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
    container_height = 80

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

  filterInView: () ->
    $(window).scroll()
    return $('#filter_container').data('inview')


  paneLeftPosition: () ->
    if this.filterInView()
      return '0px'
    else
      items_container = $("#items")
      window_left = $(window).scrollLeft()
      left =  items_container.offset().left + items_container.outerWidth() - window_left
      return "#{left}px"

  positionDetailsPane: () ->
    $(this.el).css('left', "#{this.paneLeftPosition()}")

    if this.filterInView()
      $(this.el).removeClass("details-pane-fixed").addClass('details-pane-absolute')
    else
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
