@Detail = Backbone.Model.extend
  initialize: () ->
    _.extend(this, Backbone.Events)
    _.bindAll(this, 'show', 'triggerRedraw')
    return

  show: (item_model) ->
    #If selected item is already shown, hide details pane
    if this.current_item_id() == item_model.get('id')
      item_model.set({details_displayed: false})
      this.set({current_item: null})
      this.trigger('hide')
      return
    else
      #New item selected, so update current details item
      #Reset the previous current items displayed flag
      if this.current_item() != null
        this.current_item().set({details_displayed: false})

      #set the new item's displayed flag
      item_model.set({details_displayed: true})
      this.set({current_item: item_model})

    this.fetch
      url: "/items/#{this.current_item_id()}/details"
      success: this.triggerRedraw
    return

  current_item: () ->
    if this.has('current_item') && this.get('current_item') != null
      return this.get('current_item')
    else
      return null

  current_item_id: () ->
    if this.has('current_item') && this.get('current_item') != null
      return this.get('current_item').get('id')
    else
      return null

  triggerRedraw: () ->
    this.trigger('show')
    return
