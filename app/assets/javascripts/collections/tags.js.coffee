@Tags = Backbone.Collection.extend
  model: Tag

  url: '/tags'

  find_by_path: (path) ->
    return _.detect this.models, (m) ->
      return m.get('path') == path;
