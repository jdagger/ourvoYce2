@OurvoyceRouter = Backbone.Router.extend
  routes: 
    '': 'default'
    '!/item/:id': 'item'
    '!/hot_topics': 'hot_topics'
    '!/hot_topics/:filter': 'hot_topics'
    '!/hot_topics/:filter/:sort_name::sort_direction': 'hot_topics'
    '!/favorites': 'favorites'
    '!/favorites/:filter': 'favorites'
    '!/favorites/:filter/:sort_name::sort_direction': 'favorites'
    '!/tag/:tag': 'tag'
    '!/tag/:tag/:filter': 'tag'
    '!/tag/:tag/:filter/:sort_name::sort_direction': 'tag'

  initialize: () ->
    return

  default: () ->
    Navigate('hot_topics')
    return

  item: (id) ->
    OurvoyceApp.items.fetch_item(id)
    return

  hot_topics: (filter, sort_name, sort_direction) ->
    OurvoyceApp.items.fetch_hot_topics(filter, sort_name, sort_direction)
    return

  favorites: (filter, sort_name, sort_direction) ->
    OurvoyceApp.items.fetch_favorites(filter, sort_name, sort_direction)
    return

  tag: (tag, filter, sort_name, sort_direction) ->
    OurvoyceApp.items.fetch_items(tag, filter, sort_name, sort_direction)
    return
