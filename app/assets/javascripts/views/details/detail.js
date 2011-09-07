$(function(){
window.DetailView = Backbone.View.extend({
  tag: 'div',
  el: '#details',
  template: JST['details/detail'],
  
  initialize: function(){
    _.bindAll(this, 'render');
    this.model.bind('change', this.render);
  },

  render: function(){
    $(this.el).html(this.template(this.model.toJSON()));
    return this;
  }

});
});
