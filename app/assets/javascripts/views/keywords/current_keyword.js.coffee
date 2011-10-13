@CurrentKeywordView = Backbone.View.extend
  el: '#current_keyword'

  initialize: () ->
    _.bindAll(this, 'render')
    this.collection.bind('all', this.render)

  render: () ->
    $(this.el).html(this.collection.friendly_name)
    return this
