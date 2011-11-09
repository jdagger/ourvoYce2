@Item = Backbone.Model.extend
  initialize: (attributes) ->
    _.extend(this, Backbone.Events)
    _(this).bindAll('change_vote',
      'thumbs_up',
      'thumbs_down',
      'neutral',
      'thumbs_down_vote_count',
      'thumbs_up_vote_count',
      'neutral_vote_count',
      'set_thumbs_down_vote_count',
      'set_thumbs_up_vote_count',
      'set_neutral_vote_count',
      'update_vote_counts',
      'toggle_favorite'
    )
    #this.set({vote: new Vote(attributes)})
    return

  thumbs_up: () ->
    this.change_vote(1)
    return

  thumbs_down: () ->
    this.change_vote(-1)
    return

  neutral: () ->
    this.change_vote(0)
    return

  toggle_favorite: () ->
    url = "/items/#{this.get('id')}/toggle_favorite"
    this.save({}, {url: url, success: (model, response) =>
      this.set({favorite: response['favorite']})
    })
    return

  thumbs_down_vote_count: () ->
    return this.get('thumbs_down_vote_count')


  neutral_vote_count: () ->
    return this.get('neutral_vote_count')


  thumbs_up_vote_count: () ->
    return this.get('thumbs_up_vote_count')

  set_thumbs_up_vote_count: (val) ->
    this.set({thumbs_up_vote_count: val})

  set_thumbs_down_vote_count: (val) ->
    this.set({thumbs_down_vote_count: val})

  set_neutral_vote_count: (val) ->
    this.set({neutral_vote_count: val})

  
  change_vote: (new_vote) ->

    return unless OurvoyceApp.authenticated


    url = "/items/#{this.get('id')}/vote"
    previous_vote = this.get('user_vote')

    if ! previous_vote?
      this.trigger('new_vote')

    if previous_vote == new_vote
      return
    else
      this.trigger('vote_changed')



    this.save({new_vote: new_vote}, {url: url})
    this.set({user_vote: new_vote})
    this.update_vote_counts(previous_vote, new_vote)
    return

  update_vote_counts: (previous_vote, new_vote) ->
    return if previous_vote == new_vote


    if previous_vote == 1
      this.set_thumbs_up_vote_count(this.thumbs_up_vote_count() - 1)
    else if previous_vote == 0
      this.set_neutral_vote_count(this.neutral_vote_count() - 1)
    else if previous_vote == -1
      this.set_thumbs_down_vote_count(this.thumbs_down_vote_count() - 1)

    if previous_vote == 1
      this.set_thumbs_up_vote_count(this.thumbs_up_vote_count() + 1)
    else if previous_vote == 0
      this.set_neutral_vote_count(this.neutral_vote_count() + 1)
    else if previous_vote == -1
      this.set_thumbs_down_vote_count(this.thumbs_down_vote_count() + 1)

    return




