@Items = Backbone.Collection.extend
  model: Item
  url: '/Items'
  fetch_items: (keyword) ->
    if(keyword == null)
      console.log('fetch_items: null. Investigate')
      return
    url = "/items/keyword/#{keyword.get('path')}"
    OurvoyceApp.current_keyword.set({friendly_name: keyword.get('friendly_name')});
    this.fetch({url: url});
    return

