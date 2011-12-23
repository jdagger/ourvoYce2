@ItemView = Backbone.View.extend
  tag: 'div'
  className: 'item'
  template: 'items/item'

  events: 
    'click .voting .thumbs_up': 'thumbs_up_vote'
    'click .voting .neutral': 'neutral_vote'
    'click .voting .thumbs_down': 'thumbs_down_vote'
    'click .toggle-details': 'detailsClick'
    'click .favorite > a': 'toggle_favorite'

  initialize: () ->
    this.relatedTags = null

    _.bindAll(this, 'render', 
      'renderVoteIndicators',
      'renderRelatedTags',
      'renderVoteMessage',
      'renderVoteGraph',
      'thumbs_up_vote', 
      'thumbs_down_vote', 
      'neutral_vote',
      'detailsClick',
      #'selectedDetailsChanged',
      'vote_changed',
      'vote_saved',
      'vote_saving',
      'vote_error',
      'toggle_favorite',
      'favorite_changed',
      'showDetails',
      'hideDetails',
      'toggleDetails'
    )
    this.model.bind('vote_saving', this.vote_saving)
    this.model.bind('vote_changed', this.vote_changed)
    this.model.bind('vote_saved', this.vote_saved)
    this.model.bind('vote_error', this.vote_error)
    this.model.bind('change:favorite', this.favorite_changed)

    OurvoyceApp.detail.bind('showDetails', this.showDetails)
    OurvoyceApp.detail.bind('hideDetails', this.hideDetails)

    this.detailsDisplayed = false
    return


  vote_changed: () ->
    this.renderVoteIndicators()
    this.renderVoteGraph()
    #Possibly add some sort of animation indicating vote has changed
    return

  vote_saving: () ->
    this.renderVoteMessage('saving...')
    return

  vote_saved: () ->
    this.renderVoteMessage('saved')
    return
  vote_error: () ->
    this.renderVoteMessage('error')
    return

  favorite_changed: (model, val) ->
    favorite_link = $(this.el).find('.favorite > a')

    #Should create a popout view to update this count
    count_element = $("#favorites_count")
    favorite_count = parseInt(count_element.html())
    if(val)
      favorite_link.removeClass('not-selected').addClass('selected')
      count_element.html(favorite_count + 1)
    else
      favorite_link.removeClass('selected').addClass('not-selected')
      count_element.html(favorite_count - 1)
    return

  renderVoteMessage: (message) ->
    $(this.el).find('.vote-message').html(message)
    return

  toggle_favorite: (e) ->
    e.preventDefault()
    window.location = "/signup" unless OurvoyceApp.authenticated
    this.model.toggle_favorite()
    return

  renderVoteIndicators: () ->
    vote = this.model.get('user_vote')
    if vote != null
      thumbs_up_div = $(this.el).find('.vote-container .thumbs_up div')
      neutral_div = $(this.el).find('.vote-container .neutral div')
      thumbs_down_div = $(this.el).find('.vote-container .thumbs_down div')

      if vote == 1
        thumbs_up_div.removeClass('thumbs-up-vote-gray').addClass('thumbs-up-vote')
        thumbs_down_div.removeClass('thumbs-down-vote').addClass('thumbs-down-vote-gray')
        neutral_div.removeClass('neutral-vote').addClass('neutral-vote-gray')
      else if vote == 0
        thumbs_up_div.removeClass('thumbs-up-vote').addClass('thumbs-up-vote-gray')
        neutral_div.removeClass('neutral-vote-gray').addClass('neutral-vote')
        thumbs_down_div.removeClass('thumbs-down-vote').addClass('thumbs-down-vote-gray')
      else if vote == -1
        thumbs_up_div.removeClass('thumbs-up-vote').addClass('thumbs-up-vote-gray')
        thumbs_down_div.removeClass('thumbs-down-vote-gray').addClass('thumbs-down-vote')
        neutral_div.removeClass('neutral-vote').addClass('neutral-vote-gray')
    return

  renderVoteGraph: () ->
    thumbs_up_vote_count = this.model.thumbs_up_vote_count()
    thumbs_down_vote_count = this.model.thumbs_down_vote_count()
    neutral_vote_count = this.model.neutral_vote_count()

    max_count = Math.max(thumbs_up_vote_count, thumbs_down_vote_count, neutral_vote_count)
    #console.log("Invalid vote count detected(ItemView)") if Math.min(thumbs_up_vote_count, thumbs_down_vote_count, neutral_vote_count) < 0

    # -3 at end is for the cap height at the top of the bars
    container_height = $(this.el).find('.mini-vote-chart').css('height').replace(/px/, "") - 3

    thumbs_up_bar = $(this.el).find('.mini-vote-chart .thumbs-up div')
    thumbs_down_bar = $(this.el).find('.mini-vote-chart .thumbs-down div')
    neutral_bar = $(this.el).find('.mini-vote-chart .neutral div')

    thumbs_up_bar.animate
      height: Math.ceil(container_height * thumbs_up_vote_count / max_count) + "px"
    thumbs_down_bar.animate
      height: Math.ceil(container_height * thumbs_down_vote_count / max_count) + "px"
    neutral_bar.animate
      height: Math.ceil(container_height * neutral_vote_count / max_count) + "px"
    return


  render: () ->
    $(this.el).html(JST[this.template](this.model.toJSON()))

    this.renderRelatedTags()
    this.renderVoteIndicators()
    this.renderVoteGraph()

    return this

  renderRelatedTags: () ->
    relatedTagView = new RelatedTagsView({el: $(this.el).find('.related-tags-container'), collection: this.relatedTags})
    return

  #User clicked to expand details
  detailsClick: (e) ->
    e.preventDefault()
    if this.detailsDisplayed
      OurvoyceApp.detail.hideDetails()
    else
      OurvoyceApp.detail.showDetails(this.model)
    return

  showDetails: (item) ->
    if this.model.get('id') == item.get('id')
      this.toggleDetails(true)
    else
      this.toggleDetails(false)
    return

  hideDetails: () ->
    this.toggleDetails(false)
    return

  toggleDetails: (visible) ->
    this.detailsDisplayed = visible
    if visible
      $(this.el).find('.toggle-details').addClass('bluebg')
      $(this.el).find('.toggle-details .details-arrow').removeClass('hidden').addClass('expanded')
    else
      $(this.el).find('.toggle-details').removeClass('bluebg')
      $(this.el).find('.toggle-details .details-arrow').removeClass('expanded').addClass('hidden')
    return

  #selectedDetailsChanged: (id) ->
  ##if OurvoyceApp.detail.get('id') == this.model.get('id') && OurvoyceApp.detailView.isVisible()
  #console.log "toggle click"
  ##if this.model.get('show_details')
  #$(this.el).find('.toggle-details').addClass('bluebg')
  #$(this.el).find('.toggle-details .details-arrow').removeClass('hidden').addClass('expanded')
  #else
  #$(this.el).find('.toggle-details').removeClass('bluebg')
  #$(this.el).find('.toggle-details .details-arrow').removeClass('expanded').addClass('hidden')
  #return

  thumbs_up_vote: (e) ->
    e.preventDefault()
    if ! OurvoyceApp.authenticated
      window.location = "/signup"
      return
    this.model.thumbs_up()
    return

  thumbs_down_vote: (e) ->
    e.preventDefault()
    if ! OurvoyceApp.authenticated
      window.location = "/signup"
      return
    this.model.thumbs_down()
    return

  neutral_vote: (e) ->
    e.preventDefault()
    if ! OurvoyceApp.authenticated
      window.location = "/signup"
      return
    this.model.neutral()
    return
