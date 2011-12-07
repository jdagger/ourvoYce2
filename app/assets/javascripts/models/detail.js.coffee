@Detail = Backbone.Model.extend

  initialize: () ->
    _.extend(this, Backbone.Events)
    #_.bindAll(this, 'fetchDetails', 'showDetails', 'hideDetails')
    _.bindAll(this, 'showDetails', 'hideDetails', 'fetchDetails')
    this._loadedItem = null
    return

  fetchDetails: (item) ->
    this.fetch
      url: "/items/#{item.get('id')}/details"
      success: () =>
        this.trigger('newDetails')

        return
    return

  parse: (data) ->
    this._loadedItem = data
    #return data.items
    return this

  showDetails: (item) ->
    if this._loadedItem == null || (this._loadedItem.id != item.get('id'))
      this.fetchDetails(item)
      #this.loadedItem = item

    this.trigger('showDetails', item)
    return

  hideDetails: () ->
    this.trigger('hideDetails')
    return

  id: () ->
    return null if this._loadedItem == null
    return this._loadedItem.id

  name: () ->
    return "" if this._loadedItem == null
    return this._loadedItem.name

  thumbsUpVoteCount: () ->
    return 0 if this._loadedItem == null
    return this._loadedItem.thumbs_up_vote_count

  thumbsDownVoteCount: () ->
    return 0 if this._loadedItem == null
    return this._loadedItem.thumbs_down_vote_count

  neutralVoteCount: () ->
    return 0 if this._loadedItem == null
    return this._loadedItem.neutral_vote_count

  website: () ->
    return "" if this._loadedItem == null
    return this._loadedItem.website

  wikipedia: () ->
    return "" if this._loadedItem == null
    return this._loadedItem.wikipedia

