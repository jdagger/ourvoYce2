window.DetailView = Backbone.View.extend({
  tag: 'div',
  el: '#details',
  
  initialize: function(){
    _.bindAll(this, 'render');
    this.model.bind('change', this.render);
  },

  render: function(){
    $(this.el).html(ich.detail_template(this.model.toJSON()));
    return this;
  }

});
