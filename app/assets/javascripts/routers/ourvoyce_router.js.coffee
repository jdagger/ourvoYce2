@OurvoyceRouter = Backbone.Router.extend
  routes: 
    'k/:keyword': 'keyword'
    'k/:keyword/:filter': 'keyword'
    'k/:keyword/:filter/:sort_name::sort_direction': 'keyword'

  initialize: () ->
    return

  keyword: (keyword, filter, sort_name, sort_direction) ->
    OurvoyceApp.items.fetch_items(keyword, filter, sort_name, sort_direction)
    return
