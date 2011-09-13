$(function(){
  window.KeywordView = Backbone.View.extend({
    tag: 'li',
  className: 'keyword',
  template: JST['keywords/keyword'],

  events: {
    'click a': 'click'
  },

  initialize: function(){
    _.bindAll(this, 'render', 'click');
  },

  click: function(e){
    e.preventDefault();
    OurvoyceApp.router.navigate('k/' + this.model.get('path'));
    OurvoyceApp.items.fetch_items(this.model);
  },

  render: function(){
    $(this.el).html(this.template(this.model.toJSON()));
    return this;
  }
  });
});
