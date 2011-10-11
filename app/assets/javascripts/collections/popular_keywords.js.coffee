@PopularKeywords = Keywords.extend
  find_by_path: (path) ->
    return _.detect this.models, (m) ->
      return m.get('_id') == path;
