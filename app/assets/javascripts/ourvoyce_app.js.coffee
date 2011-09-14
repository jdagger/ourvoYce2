@OurvoyceApp =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (keyword_friendly_name, popular_keywords, items) ->
    this.popular_keywords = new PopularKeywords(popular_keywords)
    this.items = new Items(items)
    this.current_keyword = new CurrentKeyword({friendly_name: keyword_friendly_name})
    this.details = new Detail()
    this.router = new OurvoyceRouter()
    Backbone.history.start({pushState: true})
    return
