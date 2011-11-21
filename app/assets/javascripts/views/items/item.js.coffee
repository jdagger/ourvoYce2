@ItemView = Backbone.View.extend
  tag: 'div'
  className: 'item'
  template: 'items/item'

  events: 
    'click .voting .thumbs_up': 'thumbs_up_vote'
    'click .voting .neutral': 'neutral_vote'
    'click .voting .thumbs_down': 'thumbs_down_vote'
    'click .toggle-details': 'toggle_details'
    'click .favorite > a': 'toggle_favorite'
    #'click .related-tags > a': 'related_tag_click'

  initialize: () ->
    _.bindAll(this, 'render', 
      'thumbs_up_vote', 
      'thumbs_down_vote', 
      'neutral_vote',
      'toggle_details',
      'selected_details_changed',
      'vote_changed',
      'toggle_favorite',
      'favorite_changed'
      #'related_tag_click'
    )
    OurvoyceApp.details.bind('change:current_details', this.selected_details_changed)
    this.model.bind('vote_changed', this.vote_changed)
    this.model.bind('change:favorite', this.favorite_changed)
    return

  vote_changed: () ->
    #Possibly add some sort of animation indicating vote has changed
    return

  #related_tag_click: (e) ->
  #e.preventDefault()
  #OurvoyceApp.router.navigate($(e.target).attr('href').substr(1), true)
  #return

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

  toggle_favorite: (e) ->
    e.preventDefault()

    window.location = "/signup" unless OurvoyceApp.authenticated

    this.model.toggle_favorite()
    return


  render: () ->
    $(this.el).html(JST[this.template](this.model.toJSON()))

    vote = this.model.get('user_vote')
    if vote != null
      thumbs_up_img = $(this.el).find('.thumbs_up img')
      thumbs_down_img = $(this.el).find('.thumbs_down img')
      neutral_img = $(this.el).find('.neutral img')

      if vote == 1
        thumbs_down_img.attr('src', '/assets/site/thumbdown-gray.gif')
        neutral_img.attr('src', '/assets/site/thumbneutral-gray.gif')
      else if vote == 0
        thumbs_down_img.attr('src', '/assets/site/thumbdown-gray.gif')
        thumbs_up_img.attr('src', '/assets/site/thumbup-gray.gif')
      else if vote == -1
        thumbs_up_img.attr('src', '/assets/site/thumbup-gray.gif')
        neutral_img.attr('src', '/assets/site/thumbneutral-gray.gif')

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

    thumbs_up_bar.css('height', Math.ceil(container_height * thumbs_up_vote_count / max_count) + "px")
    thumbs_down_bar.css('height', Math.ceil(container_height * thumbs_down_vote_count / max_count) + "px")
    neutral_bar.css('height', Math.ceil(container_height * neutral_vote_count / max_count) + "px")
    return this


  toggle_details: (e) ->
    e.preventDefault()
    OurvoyceApp.details.load(this.model.get('id'))
    return


  selected_details_changed: (details) ->
    current_id = details.get('current_details')
    if this.model.get('id') == current_id
      $(this.el).find('.toggle-details').addClass('bluebg')
    else
      $(this.el).find('.toggle-details').removeClass('bluebg')
    return

  thumbs_up_vote: (e) ->
    e.preventDefault()
    if ! OurvoyceApp.authenticated
      window.location = "/signup"
      return
    this.model.thumbs_up()
    this.render()
    return

  thumbs_down_vote: (e) ->
    e.preventDefault()
    if ! OurvoyceApp.authenticated
      window.location = "/signup"
      return
    this.model.thumbs_down()
    this.render()
    return

  neutral_vote: (e) ->
    e.preventDefault()
    if ! OurvoyceApp.authenticated
      window.location = "/signup"
      return
    this.model.neutral()
    this.render()
    return
