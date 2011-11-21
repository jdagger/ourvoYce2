@HotTopicTagsView = Backbone.View.extend
  tagName: 'ul'
  el: '#hot-topic-tags'
  template: 'tags/hot_topic_tags'

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
