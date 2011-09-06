var OurvoyceRouter = Backbone.Router.extend({
  routes: {
    'k/:keyword': 'keyword'
  },

    initialize: function(){
      this.popularKeywordsView = new PopularKeywordsView({collection: window.popular_keywords});
      this.popularKeywordsView.render();

      this.itemsView = new ItemsView({collection: window.items});
      this.itemsView.render();

      this.detailView = new DetailView({model: window.details});
    },

    keyword: function(keyword){
      //alert(keyword);
    }

});
