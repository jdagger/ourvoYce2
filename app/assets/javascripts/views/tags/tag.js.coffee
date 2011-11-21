@TagView = Backbone.View.extend
  tag: 'li'
  className: 'tag'
  template: 'tags/tag'

  #events: 
    #'click a': 'click'

  initialize: () ->
    #_.bindAll(this, 'render', 'click')
    _.bindAll(this, 'render')
    return


  #click: (e) ->
  #e.preventDefault()
  #Navigate("tag", this.model.get('path'))
  #return

  render: () ->
    $(this.el).html(JST[this.template](this.model.toJSON()))
    return this
