$(function(){
  window.DetailView = Backbone.View.extend({
    tag: 'div',
  el: '#details',
  template: JST['details/detail'],

  initialize: function(){
    _.bindAll(this, 'render', 'hide');
    this.model.bind('redraw', this.render);
    this.model.bind('hide', this.hide);
  },

  render: function(){
    $(this.el).html(this.template(this.model.toJSON()));

    thumbs_up_count = this.model.get('thumbs_up_count');
    neutral_count = this.model.get('neutral_count');
    thumbs_down_count = this.model.get('thumbs_down_count');
    max_height = Math.max(thumbs_up_count, thumbs_down_count, neutral_count);

    //container_height = $(this.el).find('.vote-chart').css('height').replace(/px/, '');
    container_height = 50;

    thumbs_up_element = $(this.el).find('.vote-chart .green-height');
    neutral_element = $(this.el).find('.vote-chart .orange-height');
    thumbs_down_element = $(this.el).find('.vote-chart .red-height');

    $(this.el).find('.thumbs-up .votenumber').html(thumbs_up_count);
    $(this.el).find('.neutral .votenumber').html(neutral_count);
    $(this.el).find('.thumbs-down .votenumber').html(thumbs_down_count);

    thumbs_up_element.css('height', Math.ceil(container_height * thumbs_up_count / max_height) + "px");
    neutral_element.css('height', Math.ceil(container_height * neutral_count / max_height) + "px");
    thumbs_down_element.css('height', Math.ceil(container_height * thumbs_down_count / max_height) + "px");

    if(! $(this.el).is(':visible')){
      $(this.el).show('slide', {direction: 'left'}, 1000);
    }
    return this;
  },

  hide: function(){
    if($(this.el).is(':visible')){
      $(this.el).hide('slide', {direction: 'left'}, 1000);
    }

  }

  });
});
