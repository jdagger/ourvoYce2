window.ItemView = Backbone.View.extend({
  tag: 'div',
  className: 'item',

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
    $(this.el).html(ich.item_template(this.model.toJSON()));
    return this;
  },

  details: function(e){
    e.preventDefault();
    window.details.load(this.model.get("id"));
  },

  thumbs_up_vote: function(e){
    e.preventDefault();
    this.model.thumbs_up();
  },

  thumbs_down_vote: function(e){
    e.preventDefault();
    this.model.thumbs_down();
  },

  neutral_vote: function(e){
    e.preventDefault();
    this.model.neutral();
  }

});
