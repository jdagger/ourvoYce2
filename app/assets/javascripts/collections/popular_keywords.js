var PopularKeywords = Keywords.extend({
  find_by_path: function(path){
    return _.detect(this.models, function(m){return m.get('path') == path; });
  }
});
