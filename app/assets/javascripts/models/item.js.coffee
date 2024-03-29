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
      'toggle_favorite',
      'showDetails'
    )
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

  showDetails: () ->
    this.collection.showDetails(this)
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

    previous_vote = this.get('user_vote')
    return if previous_vote == new_vote

    this.trigger('vote_saving')

    this.save({new_vote: new_vote}, 
      url: "/items/#{this.get('id')}/vote",
      success: (model, response) =>
        this.update_vote_counts(previous_vote, new_vote)
        this.set({user_vote: new_vote})
        this.trigger('new_vote') if ! previous_vote?
        this.trigger('vote_changed') if previous_vote != new_vote
        this.trigger('vote_saved')
        return
      error: (model, response) =>
        this.trigger('vote_error')
        return
    )
    return


  update_vote_counts: (previous_vote, new_vote) ->
    return if previous_vote == new_vote


    if previous_vote == 1
      this.set_thumbs_up_vote_count(this.thumbs_up_vote_count() - 1)
    else if previous_vote == 0
      this.set_neutral_vote_count(this.neutral_vote_count() - 1)
    else if previous_vote == -1
      this.set_thumbs_down_vote_count(this.thumbs_down_vote_count() - 1)

    if new_vote == 1
      this.set_thumbs_up_vote_count(this.thumbs_up_vote_count() + 1)
    else if new_vote == 0
      this.set_neutral_vote_count(this.neutral_vote_count() + 1)
    else if new_vote == -1
      this.set_thumbs_down_vote_count(this.thumbs_down_vote_count() + 1)
    return




