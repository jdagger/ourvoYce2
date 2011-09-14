@Items = Backbone.Collection.extend
  model: Item
  url: '/Items'
  fetch_items: (keyword) ->
    url = "/items/keyword/#{keyword.get('path')}"
    OurvoyceApp.current_keyword.set({friendly_name: keyword.get('friendly_name')});
    this.fetch({url: url});
    return

