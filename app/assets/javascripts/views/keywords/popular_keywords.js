$(function(){
  window.PopularKeywordsView = Backbone.View.extend({
    tagName: 'ul',
    el: '#popular-keywords',
    template: JST['keywords/popular_keywords'],

    initialize: function(){
      _.bindAll(this, 'render', 'renderKeyword');
    },

    events: {
    },

    render: function(){
      $(this.el).html(this.template());
      this.collection.each(this.renderKeyword);
      return this;
    },

    renderKeyword: function(keyword){
      var view = new KeywordView({
        model: keyword
      });
      this.$('ul').append(view.render().el);
      return this;
    }
  });
});
