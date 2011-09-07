var OurvoyceRouter = Backbone.Router.extend({
  routes: {
    'k/:keyword': 'keyword'
  },

    initialize: function(){
      this.popularKeywordsView = new PopularKeywordsView({collection: window.popular_keywords});
      this.popularKeywordsView.render();
      
      this.currentKeywordView = new CurrentKeywordView({model: window.current_keyword});
      this.currentKeywordView.render();

      this.itemsView = new ItemsView({collection: window.items});
      this.itemsView.render();

      this.detailView = new DetailView({model: window.details});
    },

    keyword: function(keyword){
      //alert('navigate');
      //TODO: this is firing on initial load.  Try to block
      keyword_model = window.popular_keywords.find_by_path(keyword);
      window.items.fetch_items(keyword_model);
    }

});
