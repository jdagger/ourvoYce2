@TagView = Backbone.View.extend
  tag: 'li'
  className: 'tag'
  template: 'tags/tag'

  events: 
    'click a': 'click'

  initialize: () ->
    _.bindAll(this, 'render', 'click')
    return


  click: (e) ->
    e.preventDefault()
    console.log 'navigating tag clicked'
    Navigate("tag", this.model.get('path'))
    return

  render: () ->
    $(this.el).html($.tmpl(this.template, this.model.toJSON()))
    return this
