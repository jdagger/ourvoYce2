@Items = Backbone.Collection.extend
  model: Item
  url: '/Items'

  initialize: (collection, params) ->
    this.keyword = params.keyword_path
    this.friendly_name = params.keyword_friendly_name

  fetch_items: (keyword, filter, sort) ->
    #TODO Move record_counter to own view
    $("#record_counter").html("retrieving records...")

    this.keyword = keyword

    if filter? and filter.length > 0
      this.filter = filter
    if sort? and sort.length > 0
      this.sort_details = sort

    url = "/items/keyword/#{this.keyword}"
    this.fetch({url: url, data: {filter: this.filter, sort: this.sort_details}});

    return

  parse: (data) ->
    OurvoyceApp.item_ids = data.item_ids if data.item_ids?
    return data.items


  fetch_next: () ->
    $("#record_counter").html("retrieving records...")
    item_count = _.size(OurvoyceApp.item_ids)
    size = this.length

    if size >= item_count
      $("#record_counter").html("all records loaded")
      return

    items_to_fetch = OurvoyceApp.item_ids.slice(size, size + 10)
    url = "/items/fetch"
    this.fetch
      url: "/items/fetch"
      add: true
      data: 
        item_ids: items_to_fetch
    return


