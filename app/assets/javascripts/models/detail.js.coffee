@Detail = Backbone.Model.extend

  initialize: () ->
    _.extend(this, Backbone.Events)
    _.bindAll(this, 'showDetails', 'hideDetails', 'vote_changed', 'fetchDetails')
    this.item_details = null
    this.item_model = null
    return

  fetchDetails: (item) ->
    #Parse if overridden, so fetch does not replace Detail model with item
    this.fetch
      url: "/items/#{item.get('id')}/details"
      success: () =>
        #TODO: Possible memory leak by not unbinding previously loaded items
        this.item_model = item
        this.item_model.bind('vote_changed', this.vote_changed)
        this.trigger('newDetails')
        return
    return

  parse: (data) ->
    this.item_details = data
    #return data.items
    return this

  vote_changed: () ->
    this.trigger('vote_changed')
    return

  showDetails: (item) ->
    if this.item_details == null || (this.item_details.id != item.get('id'))
      this.fetchDetails(item)

    this.trigger('showDetails', item)
    return

  hideDetails: () ->
    this.trigger('hideDetails')
    return

  id: () ->
    return null if this.item_details == null
    return this.item_details.id

  name: () ->
    return "" if this.item_details == null
    return this.item_details.name

  thumbsUpVoteCount: () ->
    return 0 if this.item_details == null
    return this.item_model.get('thumbs_up_vote_count')

  thumbsDownVoteCount: () ->
    return 0 if this.item_details == null
    return this.item_model.get('thumbs_down_vote_count')

  neutralVoteCount: () ->
    return 0 if this.item_details == null
    return this.item_model.get('neutral_vote_count')

  website: () ->
    return "" if this.item_details == null
    return this.item_details.website

  wikipedia: () ->
    return "" if this.item_details == null
    return this.item_details.wikipedia

