@UserVoteCountView = Backbone.View.extend
  el: '#user_vote_count'

  initialize: () ->
    _(this).bindAll('render')
    this.model.bind('vote_count_changed', this.render)
    this.render()
    return

  render: () ->
    $(this.el).html(this.model.user_vote_count)
    return this

