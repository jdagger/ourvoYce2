@KeywordView = Backbone.View.extend
  tag: 'li'
  className: 'keyword'
  template: 'keywords/keyword'

  events: 
    'click a': 'click'

  initialize: () ->
    _.bindAll(this, 'render', 'click')
    return


  click: (e) ->
    e.preventDefault()
    KeywordNavigate(this.model.get('_id'))
    return

  render: () ->
    $(this.el).html($.tmpl(this.template, this.model.toJSON()))
    return this
