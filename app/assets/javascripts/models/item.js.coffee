@Item = Backbone.Model.extend
  initialize: (attributes) ->
    this.set({vote: new Vote(attributes.vote)})
    console.log attributes.vote
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


  thumbs_down_count: () ->
    return this.get('vote').get('thumbs_down_count')


  neutral_count: () ->
    return this.get('vote').get('neutral_count')


  thumbs_up_count: () ->
    return this.get('vote').get('thumbs_up_count')

  set_thumbs_up_count: (val) ->
    this.get('vote').set({thumbs_up_count: val})

  set_thumbs_down_count: (val) ->
    this.get('vote').set({thumbs_down_count: val})

  set_neutral_count: (val) ->
    this.get('vote').set({neutral_count: val})

  
  change_vote: (new_vote) ->
    url = "/items/#{this.get('_id')}/vote"
    previous_vote = this.get('user_vote')
    return if previous_vote == new_vote

    this.save({new_vote: new_vote}, {url: url})
    this.set({user_vote: new_vote})
    this.update_vote_counts(previous_vote, new_vote)
    return

  update_vote_counts: (previous_vote, new_vote) ->
    return if previous_vote == new_vote


    if previous_vote == 1
      this.set_thumbs_up_count(this.thumbs_up_count() - 1)
    else if previous_vote == 0
      this.set_neutral_count(this.neutral_count() - 1)
    else if previous_vote == -1
      this.set_thumbs_down_count(this.thumbs_down_count() - 1)

    if previous_vote == 1
      this.set_thumbs_up_count(this.thumbs_up_count() + 1)
    else if previous_vote == 0
      this.set_neutral_count(this.neutral_count() + 1)
    else if previous_vote == -1
      this.set_thumbs_down_count(this.thumbs_down_count() + 1)

    return




