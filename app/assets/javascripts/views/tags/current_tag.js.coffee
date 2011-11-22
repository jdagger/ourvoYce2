@CurrentTagView = Backbone.View.extend
  el: '#current_tag'

  initialize: () ->
    _.bindAll(this, 'render')
    this.collection.bind('all', this.render)
    this.render()
    return

  render: () ->
    $(this.el).html(this.collection.friendly_name)
    return this
