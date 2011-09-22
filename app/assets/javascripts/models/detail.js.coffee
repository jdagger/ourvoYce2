@Detail = Backbone.Model.extend
  initialize: () ->
    _.extend(this, Backbone.Events)
    _.bindAll(this, 'load', 'triggerRedraw')
    return

  load: (id) ->
    if this.current_details() == id
      this.set({current_details: null})
      this.trigger('hide')
      return
    else
      this.set({current_details: id})

    url = "/items/#{id}/details"
    this.fetch
      url: url
      success: this.triggerRedraw
    return

  current_details: () ->
    return this.get('current_details')

  triggerRedraw: () ->
    this.trigger('redraw')
    return
