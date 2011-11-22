@DetailView = Backbone.View.extend
  tag: 'div'
  el: '#item_details'
  template: 'details/detail'

  initialize: () ->
    _.bindAll(this, 'render', 'hide', 'scroll')
    this.model.bind('redraw', this.render)
    this.model.bind('hide', this.hide)
    $(window).scroll(this.scroll)
    return

  render: () ->
    $(this.el).html(JST[this.template](this.model.toJSON()))

    window.createSWFObjects()

    thumbs_up_vote_count = 0
    neutral_vote_count = 0
    thumbs_down_vote_count = 0

    #vote = this.model.get('vote')
    #if vote != undefined
      #thumbs_up_vote_count = vote.thumbs_up_vote_count
      #neutral_vote_count = vote.neutral_vote_count
      #thumbs_down_vote_count = vote.thumbs_down_vote_count

    thumbs_up_vote_count = this.model.get('thumbs_up_vote_count')
    neutral_vote_count = this.model.get('neutral_vote_count')
    thumbs_down_vote_count = this.model.get('thumbs_down_vote_count')

    max_height = Math.max(thumbs_up_vote_count, thumbs_down_vote_count, neutral_vote_count, 1)

    #TODO: Determine actual height by examining html
    container_height = 50

    thumbs_up_element = $(this.el).find('.vote-chart .green-height')
    neutral_element = $(this.el).find('.vote-chart .orange-height')
    thumbs_down_element = $(this.el).find('.vote-chart .red-height')

    $(this.el).find('.thumbs-up .votenumber').html(thumbs_up_vote_count)
    $(this.el).find('.neutral .votenumber').html(neutral_vote_count)
    $(this.el).find('.thumbs-down .votenumber').html(thumbs_down_vote_count)

    thumbs_up_element.css('height', Math.ceil(container_height * thumbs_up_vote_count / max_height) + "px")
    neutral_element.css('height', Math.ceil(container_height * neutral_vote_count / max_height) + "px")
    thumbs_down_element.css('height', Math.ceil(container_height * thumbs_down_vote_count / max_height) + "px")

    this.setPosition()
    if ! $(this.el).is(':visible')
      $(this.el).show('slide', {direction: 'left'}, 500, () ->
        #$('#general_details').hide()
      ) 
    return this


  hide: () ->
    if $(this.el).is(':visible')
      #$('#general_details').show()
      $(this.el).hide('slide', {direction: 'left'}, 500)
    return this


  setPosition: () ->
    items = $("#items")
    filter = $("#filter_box")
    details = $("#details")
    content_top = items.offset().top
    window_top = $(window).scrollTop()
    window_left = $(window).scrollLeft()
    filter_height = parseInt(filter.css("height").replace(/px/, ''))
    filter_bottom = filter.offset().top + filter_height

    #if(window_top > content_top)
    if(filter_bottom > content_top)
      details.addClass("fixed")
      left = items.offset().left + items.outerWidth() - window_left
      #details.css("position", "fixed")
      #margin_top = parseInt($("#items").css('margin-top').replace(/px/, ''))
      #details.css("top", "#{filter_height + margin_top}px")
      details.css("left", "#{left}px")
    else
      #details.css("position", "absolute")
      #details.css("top", "0px")
      details.css("left", "")
      details.removeClass("fixed")



  scroll: () ->
    this.setPosition()
    return
