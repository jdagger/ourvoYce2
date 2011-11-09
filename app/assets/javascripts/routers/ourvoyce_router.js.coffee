@OurvoyceRouter = Backbone.Router.extend
  routes: 
    'hot_topics': 'hot_topics'
    'hot_topics/:filter': 'hot_topics'
    'hot_topics/:filter/:sort_name::sort_direction': 'hot_topics'
    'favorites': 'favorites'
    'favorites/:filter': 'favorites'
    'favorites/:filter/:sort_name::sort_direction': 'favorites'
    'tag/:tag': 'tag'
    'tag/:tag/:filter': 'tag'
    'tag/:tag/:filter/:sort_name::sort_direction': 'tag'

  initialize: () ->
    return

  hot_topics: (filter, sort_name, sort_direction) ->
    console.log 'hot_topics router'
    OurvoyceApp.items.fetch_hot_topics(filter, sort_name, sort_direction)
    return

  favorites: (filter, sort_name, sort_direction) ->
    console.log 'favorites router'
    OurvoyceApp.items.fetch_favorites(filter, sort_name, sort_direction)
    return

  tag: (tag, filter, sort_name, sort_direction) ->
    console.log 'tag router'
    OurvoyceApp.items.fetch_items(tag, filter, sort_name, sort_direction)
    return
