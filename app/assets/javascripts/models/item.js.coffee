@Item = Backbone.Model.extend
  initialize: (attributes) ->
    console.log "ITEM INITIALIZER"
    console.log attributes
    this.set({vote: new Vote(attributes.vote)})
    console.log this
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
    console.log("Previous Vote: #{previous_vote}")
    return if previous_vote == new_vote

    this.save({new_vote: new_vote}, {url: url})
    this.set({user_vote: new_vote})
    this.update_vote_counts(previous_vote, new_vote)
    return

  update_vote_counts: (previous_vote, new_vote) ->
    return if previous_vote == new_vote


    if previous_vote == 1
      console.log("Before: " + this.thumbs_up_count())
      this.set_thumbs_up_count(this.thumbs_up_count() - 1)
      console.log("After: " + this.thumbs_up_count())
    else if previous_vote == 0
      #vote.set({neutral_count: this.neutral_count() - 1})
      this.set_neutral_count(this.neutral_count() - 1)
    else if previous_vote == -1
      #vote.set({thumbs_down_count: this.thumbs_down_count() - 1})
      this.set_thumbs_down_count(this.thumbs_down_count() - 1)

    if previous_vote == 1
      #vote.set({thumbs_up_count: this.thumbs_up_count() + 1})
      this.set_thumbs_up_count(this.thumbs_up_count() + 1)
    else if previous_vote == 0
      #vote.set({neutral_count: this.neutral_count() + 1})
      this.set_neutral_count(this.neutral_count() + 1)
    else if previous_vote == -1
      #vote.set({thumbs_down_count: this.thumbs_down_count() + 1})
      this.set_thumbs_down_count(this.thumbs_down_count() + 1)

    #this.set({vote: vote})
    return




