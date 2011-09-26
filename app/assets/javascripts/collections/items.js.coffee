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

  parse: (data) ->
    OurvoyceApp.item_ids = data.item_ids if data.item_ids?
    return data.items


  fetch_next: () ->
    item_count = _.size(OurvoyceApp.item_ids)
    size = this.length
    return if size >= item_count
    items_to_fetch = OurvoyceApp.item_ids.slice(size, size + 10)
    url = "/items/fetch"
    this.fetch
      url: "/items/fetch"
      add: true
      data: 
        item_ids: items_to_fetch

      success: (collection, response) ->
        console.log(response)
        return
    return


