@PopularKeywordsView = Backbone.View.extend
  tagName: 'ul'
  el: '#popular-keywords'
  template: 'keywords/popular_keywords'

  initialize: () ->
    _.bindAll(this, 'render', 'renderKeyword')
    return


  render: () ->
    alert($.tmpl(this.template, {}))
    $(this.el).html($.tmpl(this.template, {}))
    this.collection.each(this.renderKeyword)
    return this


  renderKeyword: (keyword) -> 
    view = new KeywordView({model: keyword})
    this.$('ul').append(view.render().el)
    return this
