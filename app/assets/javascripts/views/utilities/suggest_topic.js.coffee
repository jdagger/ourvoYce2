@SuggestTopicView = Backbone.View.extend
  el: '#suggest-topic'
  events: 
    'submit form#suggest-topic-form': 'suggest_topic_click'

  initialize: () ->
    _.bindAll(this, 'suggest_topic_click', 'submitted_success', 'submitted_error')

    this.model.bind('submitted_success', this.submitted_success)
    this.model.bind('submitted_error', this.submitted_error)
    return

  suggest_topic_click: (e) ->
    e.preventDefault()
    this.model.submit_suggest_topic($(this.el).find('#suggest-topic-input').val())
    return

  submitted_success: () ->
    $(this.el).find("#suggest-topic-message").html("We've received your suggestion. Thanks!")
    $(this.el).find('#suggest-topic-input').val('')
    return

  submitted_error: () ->
    $(this.el).find("#suggest-topic-message").html('An error was encountered. Please try again.')
    return
