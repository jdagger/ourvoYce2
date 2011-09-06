var Items = Backbone.Collection.extend({
  model: Item,
  url: '/items',
  fetch_items: function(keyword){
    var url = "/items/keyword/" + keyword;
    this.fetch({url: url});
  }
});
