var Detail = Backbone.Model.extend({ 

  initialize: function(){
    _.extend(this, Backbone.Events);
    _.bindAll(this, 'load', 'triggerRedraw');
  },

  load: function(id){
    current = this.get('current_details');
    if(current == id){
      this.set({current_details: null});
      this.trigger('hide')
      return;
    }
    else{
      this.set({current_details: id});
    }

    var url = '/items/' + id + '/details'
    this.fetch({
      url: url,
      success: this.triggerRedraw
    });
  },

  triggerRedraw: function(){
    this.trigger('redraw');
  }
});
