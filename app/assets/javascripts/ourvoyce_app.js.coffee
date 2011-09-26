window.OurvoyceApp =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (keyword_friendly_name, popular_keywords, items, item_ids) ->
    this.popular_keywords = new PopularKeywords(popular_keywords)
    this.items = new Items(items)
    this.item_ids = item_ids
    this.current_keyword = new CurrentKeyword({friendly_name: keyword_friendly_name})
    this.details = new Detail()
    this.router = new OurvoyceRouter()
    Backbone.history.start({pushState: true})
    return

$ ->
  $(window).scroll(() ->
    if($(window).scrollTop() == $(document).height() - $(window).height())
      window.OurvoyceApp.items.fetch_next()
    return
  )
