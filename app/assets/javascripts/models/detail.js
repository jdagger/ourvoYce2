var Detail = Backbone.Model.extend({ 
  load: function(id){
    var url = '/items/' + id + '/details'
    this.fetch({url: url});
  }
});
