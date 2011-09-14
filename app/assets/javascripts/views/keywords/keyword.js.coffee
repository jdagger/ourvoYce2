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
    OurvoyceApp.router.navigate('k/' + this.model.get('path'))
    OurvoyceApp.items.fetch_items(this.model)
    return

  render: () ->
    $(this.el).html($.tmpl(this.template, this.model.toJSON()))
    return this
