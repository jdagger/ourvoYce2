window.OurvoyceApp =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (keyword_friendly_name, keyword_path, popular_keywords, items, item_ids) ->
    this.popular_keywords = new PopularKeywords(popular_keywords)

    #this.items = new Items(items, [{keyword_friendly_name: keyword_friendly_name, keyword_path: keyword_path}])
    this.items = new Items(items, {keyword_friendly_name: keyword_friendly_name, keyword_path: keyword_path})
    this.item_ids = item_ids

    #this.current_keyword = new CurrentKeyword({friendly_name: keyword_friendly_name})

    this.details = new Detail()

    this.router = new OurvoyceRouter()

    this.itemsView = new ItemsView({collection: OurvoyceApp.items})
    this.itemsView.render()

    this.popularKeywordsView = new PopularKeywordsView({collection: OurvoyceApp.popular_keywords})
    this.popularKeywordsView.render()

    this.recordCounterView = new RecordCounterView({collection: OurvoyceApp.items})
    this.recordCounterView.render()

    this.filterView = new FilterView()
    this.filterView.render()

    #Render after filter because contained within filter. Possibly make nested
    #this.currentKeywordView = new CurrentKeywordView({model: OurvoyceApp.current_keyword})
    #this.currentKeywordView.render()

    this.detailView = new DetailView({model: OurvoyceApp.details})

    Backbone.history.start({pushState: true, silent: true})
    return

$ ->
  $(window).scroll(() ->
    if($(window).scrollTop() == $(document).height() - $(window).height())
      window.OurvoyceApp.items.fetch_next()
    return
  )
