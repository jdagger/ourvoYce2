window.KeywordView = Backbone.View.extend({
  tag: 'li',
  className: 'keyword',

  events: {
    'click a': 'click'
  },

  initialize: function(){
    _.bindAll(this, 'render', 'click');
  },

  click: function(e){
    e.preventDefault();
    var keyword = this.model.get('path');
    window.items.fetch_items(keyword);
  },

  render: function(){
    $(this.el).html(ich.keyword_template(this.model.toJSON()));
    return this;
  }
});
