@DetailView = Backbone.View.extend
  tag: 'div'
  el: '#details'
  template: 'details/detail'

  initialize: () ->
    _.bindAll(this, 'render', 'hide')
    this.model.bind('redraw', this.render)
    this.model.bind('hide', this.hide)
    return

  render: () ->
    $(this.el).html($.tmpl(this.template, this.model.toJSON()))

    window.createSWFObjects()

    thumbs_up_count = 0
    neutral_count = 0
    thumbs_down_count = 0

    vote = this.model.get('vote')
    if vote != undefined
      thumbs_up_count = vote['thumbs_up_count']
      neutral_count = vote['neutral_count']
      thumbs_down_count = vote['thumbs_down_count']

    max_height = Math.max(thumbs_up_count, thumbs_down_count, neutral_count, 1)


    #TODO: Determine actual height by examining html
    container_height = 50

    thumbs_up_element = $(this.el).find('.vote-chart .green-height')
    neutral_element = $(this.el).find('.vote-chart .orange-height')
    thumbs_down_element = $(this.el).find('.vote-chart .red-height')

    $(this.el).find('.thumbs-up .votenumber').html(thumbs_up_count)
    $(this.el).find('.neutral .votenumber').html(neutral_count)
    $(this.el).find('.thumbs-down .votenumber').html(thumbs_down_count)

    thumbs_up_element.css('height', Math.ceil(container_height * thumbs_up_count / max_height) + "px")
    neutral_element.css('height', Math.ceil(container_height * neutral_count / max_height) + "px")
    thumbs_down_element.css('height', Math.ceil(container_height * thumbs_down_count / max_height) + "px")

    $(this.el).show('slide', {direction: 'left'}, 500) unless $(this.el).is(':visible')
    return this


  hide: () ->
    $(this.el).hide('slide', {direction: 'left'}, 500) if $(this.el).is(':visible')
    return this
