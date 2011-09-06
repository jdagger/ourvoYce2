var Item = Backbone.Model.extend({

  thumbs_up: function(){
    var url = '/items/' + this.get('id') + '/vote';
    this.save({vote: 1}, {url: url});
  },

  thumbs_down: function(){
    var url = '/items/' + this.get('id') + '/vote';
    this.save({vote: -1}, {url: url});
  },

  neutral: function(){
    var url = '/items/' + this.get('id') + '/vote';
    this.save({vote: 0}, {url: url});
  }

});
