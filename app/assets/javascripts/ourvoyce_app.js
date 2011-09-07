var OurvoyceApp = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  init: function(keyword_friendly_name, popular_keywords, items){
    window.popular_keywords = new PopularKeywords(popular_keywords);
    window.items = new Items(items);
    window.current_keyword = new CurrentKeyword({friendly_name: keyword_friendly_name});
    window.details = new Detail();
    window.router = new OurvoyceRouter();
    Backbone.history.start({pushState: true});
  }
};
