@SuggestTopic = Backbone.Model.extend
  initialize: (attributes) ->
    _.extend(this, Backbone.Events)
    _.bindAll(this, 'submit_suggest_topic', 'topic_submitted_success', 'topic_submitted_error')
    return

  submit_suggest_topic: (suggestion) ->
    $.ajax
      url: "/suggest_topics/submit"
      type: 'POST'
      dataType: 'json'
      data: {suggestion: suggestion}
      success: this.topic_submitted_success
      error: this.topic_submitted_error
    return

  topic_submitted_success: (data) ->
    this.trigger('submitted_success')
    return

  topic_submitted_error: () ->
    this.trigger('submitted_error')
    return
