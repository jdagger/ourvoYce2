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

