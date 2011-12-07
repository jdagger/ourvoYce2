@Items = Backbone.Collection.extend
  model: Item
  url: '/Items'

  initialize: (collection, params) ->
    _.extend(this, Backbone.Events)
    this.tag = params.tag_path
    this.friendly_name = params.tag_friendly_name
    this.base_url = params.base_url
    this.filter = params.filter
    this.sort_name = params.sort_name
    this.sort_direction = params.sort_direction
    this.displayed_details_item = null
    return


  fetch_hot_topics: (filter, sort_name, sort_direction) ->
    url = "/hot_topics"
    $("#record_counter").html("retrieving records...")
    this.base_url = 'hot_topics'
    this.tag = ''
    this.friendly_name = 'Hot Topics'
    this.parse_parameters filter, sort_name, sort_direction
    this.fetch({url: url, data: {filter: this.filter, sort: this.sort_details}});
    return

  fetch_favorites: (filter, sort_name, sort_direction) ->
    url = "/favorites"
    $("#record_counter").html("retrieving records...")
    this.base_url = 'favorites'
    this.tag = ''
    this.friendly_name = 'Favorites'
    this.parse_parameters filter, sort_name, sort_direction
    this.fetch({url: url, data: {filter: this.filter, sort: this.sort_details}});
    return

  loaded_item_count: () ->
    return this.length

  all_records_loaded: () ->
    item_count = _.size(OurvoyceApp.item_ids)

    return this.loaded_item_count() >= item_count

  fetch_items: (tag, filter, sort_name, sort_direction) ->
    $("#record_counter").html("retrieving records...")
    this.base_url = 'tag'
    this.tag = tag
    this.parse_parameters filter, sort_name, sort_direction
    url = "/items/tag/#{this.tag}"
    this.fetch({url: url, data: {filter: this.filter, sort: this.sort_details}});
    return

  fetch_next: () ->
    $("#record_counter").html("retrieving records...")

    if this.all_records_loaded()
      $("#record_counter").html("all records loaded")
      return

    items_to_fetch = OurvoyceApp.item_ids.slice(this.loaded_item_count(), this.loaded_item_count() + 10)
    url = "/items/fetch"
    this.fetch
      url: "/items/fetch"
      add: true
      data: 
        item_ids: items_to_fetch
    return

  parse: (data) ->
    OurvoyceApp.item_ids = data.item_ids if data.item_ids?
    this.friendly_name = data.tag_friendly_name if data.tag_friendly_name
    this.tag = data.tag_path if data.tag_path
    return data.items

  parse_parameters: (filter, sort_name, sort_direction) ->
    if filter? and filter.length > 0
      this.filter = filter
    if sort_name? and sort_name.length > 0 and sort_direction? and sort_direction.length > 0 
      this.sort_details = "#{sort_name}:#{sort_direction}"
    return



