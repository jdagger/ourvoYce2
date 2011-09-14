@OurvoyceRouter = Backbone.Router.extend
  routes: 
    'k/:keyword': 'keyword'

  initialize: () ->
    this.popularKeywordsView = new PopularKeywordsView({collection: OurvoyceApp.popular_keywords})

    this.popularKeywordsView.render()
    
    this.currentKeywordView = new CurrentKeywordView({model: OurvoyceApp.current_keyword})
    this.currentKeywordView.render()

    this.itemsView = new ItemsView({collection: OurvoyceApp.items})
    this.itemsView.render()

    this.detailView = new DetailView({model: OurvoyceApp.details})
    return

  keyword: (keyword) ->
    # TODO: this is firing on initial load.  Try to block
    keyword_model = OurvoyceApp.popular_keywords.find_by_path(keyword)
    OurvoyceApp.items.fetch_items(keyword_model)
    return

