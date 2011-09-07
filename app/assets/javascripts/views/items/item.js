$(function(){
window.ItemView = Backbone.View.extend({
  tag: 'div',
  className: 'item',
  template: JST['items/item'],

  events: {
    'click .thumbs_up': 'thumbs_up_vote',
    'click .neutral': 'neutral_vote',
    'click .thumbs_down': 'thumbs_down_vote',
    'click .details': 'details'
  },

  initialize: function(){
    _.bindAll(this, 'render', 
      'thumbs_up_vote', 
      'thumbs_down_vote', 
      'neutral_vote',
      'details');
  },

  render: function(){
    $(this.el).html(this.template(this.model.toJSON()));

    vote = this.model.get('vote'); 
    if(vote != null)
    {
      thumbs_up_img = $(this.el).find('.thumbs_up img');
      thumbs_down_img = $(this.el).find('.thumbs_down img');
      neutral_img = $(this.el).find('.neutral img');

      if(vote == 1) {
        thumbs_down_img.attr('src', '/assets/site/thumbdown-gray.gif');
        neutral_img.attr('src', '/assets/site/thumbneutral-gray.gif');
      }
      else if(vote == 0){
        thumbs_down_img.attr('src', '/assets/site/thumbdown-gray.gif');
        thumbs_up_img.attr('src', '/assets/site/thumbup-gray.gif');
      }
      else if(vote == -1){
        thumbs_up_img.attr('src', '/assets/site/thumbup-gray.gif');
        neutral_img.attr('src', '/assets/site/thumbneutral-gray.gif');
      }
    }

    return this;
  },

  details: function(e){
    e.preventDefault();
    window.details.load(this.model.get("_id"));
  },

  thumbs_up_vote: function(e){
    e.preventDefault();
    this.model.thumbs_up();
    this.render();
  },

  thumbs_down_vote: function(e){
    e.preventDefault();
    this.model.thumbs_down();
    this.render();
  },

  neutral_vote: function(e){
    e.preventDefault();
    this.model.neutral();
    this.render();
  }

});
});
