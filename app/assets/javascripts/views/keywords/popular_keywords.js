$(function(){
  window.PopularKeywordsView = Backbone.View.extend({
    tagName: 'ul',
    el: '#popular-keywords',

    initialize: function(){
      _.bindAll(this, 'render', 'renderKeyword');
    },

    events: {
    },

    render: function(){
      $(this.el).html(ich.popular_keywords_template());
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
