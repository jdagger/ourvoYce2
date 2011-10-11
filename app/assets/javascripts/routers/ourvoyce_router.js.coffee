@OurvoyceRouter = Backbone.Router.extend
  routes: 
    'k/:keyword': 'keyword'
    'k/:keyword/:filter': 'keyword'
    'k/:keyword/:filter/:sort': 'keyword'

  initialize: () ->
    return

  keyword: (keyword, filter, sort) ->
    OurvoyceApp.items.fetch_items(keyword, filter, sort)
    return
