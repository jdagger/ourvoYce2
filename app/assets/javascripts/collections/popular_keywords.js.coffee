@PopularKeywords = Keywords.extend
  find_by_path: (path) ->
    _.detect this.models, (m) ->
      return m.get('path') == path;
    return null
