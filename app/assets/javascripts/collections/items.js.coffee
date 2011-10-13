@Items = Backbone.Collection.extend
  model: Item
  url: '/Items'

  initialize: (collection, params) ->
    this.keyword = params.keyword_path
    this.friendly_name = params.keyword_friendly_name
    this.filter = params.filter
    this.sort_name = params.sort_name
    this.sort_direction = params.sort_direction

  fetch_items: (keyword, filter, sort_name, sort_direction) ->
    #TODO Move record_counter to own view
    $("#record_counter").html("retrieving records...")

    this.keyword = keyword

    if filter? and filter.length > 0
      this.filter = filter
    if sort_name? and sort_name.length > 0 and sort_direction? and sort_direction.length > 0
      this.sort_details = "#{sort_name}:#{sort_direction}"

    url = "/items/keyword/#{this.keyword}"
    this.fetch({url: url, data: {filter: this.filter, sort: this.sort_details}});

    return

  parse: (data) ->
    OurvoyceApp.item_ids = data.item_ids if data.item_ids?
    this.friendly_name = data.keyword_friendly_name if data.keyword_friendly_name
    this.keyword = data.keyword_path if data.keyword_path
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


