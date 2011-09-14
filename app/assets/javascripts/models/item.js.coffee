@Item = Backbone.Model.extend

  thumbs_up: () ->
    url = "/items/#{this.get('_id')}/vote"
    this.set({user_vote: 1})
    this.save({vote: 1}, {url: url})
    return

  thumbs_down: () ->
    url = "/items/#{this.get('_id')}/vote"
    this.set({user_vote: -1})
    this.save({vote: -1}, {url: url})
    return

  neutral: () ->
    url = "/items/#{this.get('_id')}/vote"
    this.set({user_vote: 0})
    this.save({vote: 0}, {url: url})
    return

