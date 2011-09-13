var Items = Backbone.Collection.extend({
  model: Item,
  url: '/items',
  fetch_items: function(keyword){
    var url = "/items/keyword/" + keyword.get('path');
    OurvoyceApp.current_keyword.set({friendly_name: keyword.get('friendly_name')});
    this.fetch({url: url});
  }
});
