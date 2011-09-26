@ItemsView = Backbone.View.extend
  el: '#items'
  template: 'items/items'

  initialize: () ->
    _.bindAll(this, 'render', 'renderItem', 'itemAdded')
    this.collection.bind('reset', this.render)
    this.collection.bind('add', this.renderItem)
    return

  itemAdded: (item) ->
    return

  render: () ->
    $(this.el).html($.tmpl(this.template, {}))
    this.collection.each(this.renderItem)
    return this

  renderItem: (item) ->
    itemView = new ItemView({model: item})
    this.$('.items').append(itemView.render().el)
    return this


