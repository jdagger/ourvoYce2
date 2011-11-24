@Detail = Backbone.Model.extend

  initialize: () ->
    _.extend(this, Backbone.Events)
    _.bindAll(this, 'load_details')
    OurvoyceApp.items.bind('displayed_details_changed', this.load_details)
    return

  load_details: () ->
    this.fetch
      url: "/items/#{OurvoyceApp.items.displayed_details_item.get('id')}/details"
    
    return

  #load_details_for_item: (item_model) ->
  #if this.get('id') == item_model.get('id')
  #this.trigger('change')
  #return
  #
  #this.fetch
  #url: "/items/#{item_model.get('id')}/details"
  #return
