$(function(){
  window.CurrentKeywordView = Backbone.View.extend({
    el: '#current_keyword',

    initialize: function(){
      _.bindAll(this, 'render');
      this.model.bind('change:friendly_name', this.render);
    },

    render: function(){
      $(this.el).html(this.model.get('friendly_name'));
      return this;
    }
  });
});
