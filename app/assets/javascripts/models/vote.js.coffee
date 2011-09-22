@Vote = Backbone.Model.extend
  defaults:
    thumbs_up_count: 0
    thumbs_down_count: 0
    neutral_count: 0
    total_vote_count: 0

  initialize: (attributes) ->
    this.set
      thumbs_up_count: attributes.thumbs_up_count
      thumbs_down_count: attributes.thumbs_down_count
      neutral_count: attributes.neutral_count
      total_vote_count: attributes.total_vote_count

