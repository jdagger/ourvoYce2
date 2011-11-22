@RecordCounterView = Backbone.View.extend
  tag: 'div'
  el: '#record_counter'

  initialize: () ->
    _.bindAll(this, 'render')
    this.collection.bind('all', this.render)
    this.render()
    return

  render: () ->
    return this if (!this.collection? || !OurvoyceApp.item_ids?)
    records_loaded = this.collection.length
    total_records = OurvoyceApp.item_ids.length

    if records_loaded >= total_records
      $(this.el).html("all records loaded")
    else
      $(this.el).html("(#{records_loaded} / #{total_records})")
    return this
