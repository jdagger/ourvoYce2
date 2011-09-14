$(function(){
  window.ItemsView = Backbone.View.extend({
    el: '#items',
    template: 'items/items',

    initialize: function(){
      _.bindAll(this, 'render', 'renderItem');
      this.collection.bind('reset', this.render);
    },

    render: function() {
      $(this.el).html($.tmpl(this.template, {}));
      this.collection.each(this.renderItem);
      return this;
    },

    renderItem: function(item){
      var itemView = new ItemView({
        model: item
      });

      this.$('.items').append(itemView.render().el);

      return this;
    }


  });
});
