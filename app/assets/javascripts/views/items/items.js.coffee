@ItemsView = Backbone.View.extend
  el: '#items'

  initialize: () ->
    _.bindAll(this, 'render', 'renderItem', 'renderAllRecordsLoaded', 'renderLoadMoreButton', 'renderLoadMoreSection', 'renderNoItem', 'itemAdded', 'loadMoreClick')
    this.collection.bind('reset', this.render)
    this.collection.bind('add', this.renderItem)
    this.loadMoreButton = $(JST['items/load_more_button']({})).click(this.loadMoreClick)
    this.noMoreRecords = $(JST['items/all_records_loaded']({}))
    return

  itemAdded: (item) ->
    return

  render: () ->
    $(this.el).html(JST['items/items']({}))
    console.log 'items_render'
    if this.collection.length > 0
      this.collection.each(this.renderItem)
    else
      this.renderNoItem()
    return this


  loadMoreClick: (e) ->
    e.preventDefault()
    this.collection.fetch_next()
    return 

  renderAllRecordsLoaded: () ->
    $(this.el).find(this.loadMoreButton).remove()
    if $(this.el).find(this.noMoreRecords).length == 0
      $(this.el).append(this.noMoreRecords)
    return

  renderLoadMoreButton: () ->
    $(this.el).find(this.noMoreRecords).remove()
    if $(this.el).find(this.loadMoreButton).length == 0
      $(this.el).append(this.loadMoreButton)
    return

  renderNoItem: () ->
    this.$('.items').html(JST['items/no_items']({}))
    return

  renderLoadMoreSection: () ->
    if (this.collection.all_records_loaded())
      this.renderAllRecordsLoaded()
    else
      this.renderLoadMoreButton()
    return

  renderItem: (item) ->
    itemView = new ItemView({model: item})
    this.$('.items').append(itemView.render().el)
    this.renderLoadMoreSection()
    return this


