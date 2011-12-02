@ItemView = Backbone.View.extend
  tag: 'div'
  className: 'item'
  template: 'items/item'

  events: 
    'click .voting .thumbs_up': 'thumbs_up_vote'
    'click .voting .neutral': 'neutral_vote'
    'click .voting .thumbs_down': 'thumbs_down_vote'
    'click .toggle-details': 'details_click'
    'click .favorite > a': 'toggle_favorite'

  initialize: () ->
    _.bindAll(this, 'render', 
      'renderVoteIndicators',
      'renderVoteMessage',
      'renderVoteGraph',
      'thumbs_up_vote', 
      'thumbs_down_vote', 
      'neutral_vote',
      'details_click',
      'details_changed',
      'vote_changed',
      'vote_saved',
      'vote_saving',
      'vote_error',
      'toggle_favorite',
      'favorite_changed'
    )
    this.model.bind('vote_saving', this.vote_saving)
    this.model.bind('vote_changed', this.vote_changed)
    this.model.bind('vote_saved', this.vote_saved)
    this.model.bind('vote_error', this.vote_error)
    this.model.bind('change:favorite', this.favorite_changed)
    this.model.bind('change:show_details', this.details_changed)
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
    console.log("Invalid vote count detected(ItemView)") if Math.min(thumbs_up_vote_count, thumbs_down_vote_count, neutral_vote_count) < 0

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

    this.renderVoteIndicators()
    this.renderVoteGraph()

    return this


  details_click: (e) ->
    e.preventDefault()
    this.model.collection.change_selected_details(this.model)
    return


  details_changed: () ->
    #if OurvoyceApp.details.get('id') == this.model.get('id') && OurvoyceApp.detailView.isVisible()
    if this.model.get('show_details')
      $(this.el).find('.toggle-details').addClass('bluebg')
      $(this.el).find('.toggle-details .details-arrow').removeClass('hidden').addClass('expanded')
    else
      $(this.el).find('.toggle-details').removeClass('bluebg')
      $(this.el).find('.toggle-details .details-arrow').removeClass('expanded').addClass('hidden')
    return

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
