@CurrentKeywordView = Backbone.View.extend
  el: '#current_keyword'

  initialize: () ->
    _.bindAll(this, 'render')
    this.model.bind('change:friendly_name', this.render)
    return

  render: () ->
    $(this.el).html(this.model.get('friendly_name'))
    return this
