@RelatedTagsView = Backbone.View.extend
  tagName: 'ul'
  el: '#related-tags'
  template: 'tags/related_tags'

  initialize: () ->
    _.bindAll(this, 'render', 'renderTag')
    this.render()
    return

  render: () ->
    $(this.el).html(JST[this.template]({}))
    this.collection.each(this.renderTag)
    return this

  renderTag: (tag) -> 
    view = new TagView({model: tag})
    this.$('ul').append(view.render().el)
    return this
