@ItemsView = Backbone.View.extend
  el: '#items'

  initialize: () ->
    this.initial_load = true
    _.bindAll(this, 'render', 'renderMessage', 'renderItem', 'renderLoadMoreSection', 'renderNoItem', 'itemAdded', 'loadMoreClick')
    this.collection.bind('reset', this.render)
    this.collection.bind('add', this.renderItem)
    this.loadMoreButton = $(JST['items/load_more_button']({}))
    this.noMoreRecords = $(JST['items/all_records_loaded']({}))
    this.loadingIcon = $(JST['items/loading']({}))
    this.render()
    return

  itemAdded: (item) ->
    return

  render: () ->
    $(this.el).html(JST['items/items']({}))
    if this.initial_load
      this.initial_load = false
      this.renderMessage('loading')
    else if this.collection.length > 0
      this.collection.each(this.renderItem)
    else
      this.renderNoItem()
    return this

  renderMessage: (message) ->
    #Stream line this so don't need to recreate each time.
    $(this.el).find(this.loadMoreButton).remove()
    $(this.el).find(this.noMoreRecords).remove()
    $(this.el).find(this.loadingIcon).remove()
    
    switch message
      when 'loading'
        if $(this.el).find(this.loadingIcon).length == 0
          $(this.el).append(this.loadingIcon)
      when 'all_records'
        if $(this.el).find(this.noMoreRecords).length == 0
          $(this.el).append(this.noMoreRecords)
      when 'load_more'
        if $(this.el).find(this.loadMoreButton).length == 0
          this.loadMoreButton.click(this.loadMoreClick)
          $(this.el).append(this.loadMoreButton)
    return

  loadMoreClick: (e) ->
    e.preventDefault()
    this.renderMessage('loading')
    this.collection.fetch_next()
    return 



  renderNoItem: () ->
    this.$('.items').html(JST['items/no_items']({}))
    return

  renderLoadMoreSection: () ->
    if (this.collection.all_records_loaded())
      this.renderMessage('all_records')
    else
      this.renderMessage('load_more')
    return

  renderItem: (item) ->
    itemView = new ItemView({model: item})
    this.$('.items').append(itemView.render().el)
    this.renderLoadMoreSection()
    return this


