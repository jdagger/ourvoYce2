$(function(){
window.ItemView = Backbone.View.extend({
  tag: 'div',
  className: 'item',
  template: JST['items/item'],

  events: {
    'click .thumbs_up': 'thumbs_up_vote',
    'click .neutral': 'neutral_vote',
    'click .thumbs_down': 'thumbs_down_vote',
    'click .toggle-details': 'toggle_details',
  },

  initialize: function(){
    _.bindAll(this, 'render', 
      'thumbs_up_vote', 
      'thumbs_down_vote', 
      'neutral_vote',
      'toggle_details',
      'selected_details_changed');
    OurvoyceApp.details.bind('change:current_details', this.selected_details_changed);
  },

  render: function(){
    $(this.el).html(this.template(this.model.toJSON()));

    vote = this.model.get('user_vote'); 
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

    vote_counts = this.model.get('vote');
    if(vote_counts == undefined) {
      thumbs_up_count = 0;
      thumbs_down_count = 0;
      neutral_count = 0;
    }
    else {
      thumbs_up_count = vote_counts['thumbs_up_count'];
      thumbs_down_count = vote_counts['thumbs_down_count'];
      neutral_count = vote_counts['neutral_count'];
    }
    max_count = Math.max(thumbs_up_count, thumbs_down_count, neutral_count);

    //-3 at end is for the cap height at the top of the bars
    container_height = $(this.el).find('.mini-vote-chart').css('height').replace(/px/, "") - 3;

    thumbs_up_bar = $(this.el).find('.mini-vote-chart .thumbs-up div');
    thumbs_down_bar = $(this.el).find('.mini-vote-chart .thumbs-down div');
    neutral_bar = $(this.el).find('.mini-vote-chart .neutral div');

    thumbs_up_bar.css('height', Math.ceil(container_height * thumbs_up_count / max_count) + "px");
    thumbs_down_bar.css('height', Math.ceil(container_height * thumbs_down_count / max_count) + "px");
    neutral_bar.css('height', Math.ceil(container_height * neutral_count / max_count) + "px");


    return this;
  },

  toggle_details: function(e){
    e.preventDefault();
    OurvoyceApp.details.load(this.model.get('_id'));
  },

  selected_details_changed: function(details){
    current_id = details.get('current_details');
    if(this.model.get('_id') == current_id){
      $(this.el).find('.toggle-details').addClass('bluebg');
    }
    else{
      $(this.el).find('.toggle-details').removeClass('bluebg');
    }
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
