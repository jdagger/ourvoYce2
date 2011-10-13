@UserVoteCount = Backbone.Model.extend
  initialize: (params) ->
    _.extend(this, Backbone.Events)
    _(this).bindAll('new_vote')
    this.user_vote_count = params.user_vote_count
    OurvoyceApp.items.bind('new_vote', this.new_vote)
    return

  new_vote: () ->
    this.user_vote_count++
    this.trigger('vote_count_changed')
    return

