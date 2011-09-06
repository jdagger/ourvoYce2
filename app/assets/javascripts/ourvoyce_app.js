var OurvoyceApp = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  init: function(popular_keywords, items){
    window.popular_keywords = new PopularKeywords(popular_keywords);
    window.items = new Items(items);
    window.details = new Detail();
    new OurvoyceRouter();
    Backbone.history.start({pushState: true});
  }
};
