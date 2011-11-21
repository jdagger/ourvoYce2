@ItemsView = Backbone.View.extend
  el: '#items'

  initialize: () ->
    _.bindAll(this, 'render', 'renderItem', 'renderNoItem', 'itemAdded')
    this.collection.bind('reset', this.render)
    this.collection.bind('add', this.renderItem)
    return

  itemAdded: (item) ->
    return

  render: () ->
    $(this.el).html(JST['items/items']({}))
    if this.collection.length > 0
      this.collection.each(this.renderItem)
    else
      this.renderNoItem()
    return this

  renderNoItem: () ->
    this.$('.items').html(JST['items/no_items']({}))

  renderItem: (item) ->
    itemView = new ItemView({model: item})
    this.$('.items').append(itemView.render().el)
    return this


