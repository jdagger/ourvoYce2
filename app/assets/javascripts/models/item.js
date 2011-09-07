var Item = Backbone.Model.extend({

  thumbs_up: function(){
    var url = '/items/' + this.get('_id') + '/vote';
    this.set({vote: 1});
    this.save({vote: 1}, {url: url});
  },

  thumbs_down: function(){
    var url = '/items/' + this.get('_id') + '/vote';
    this.set({vote: -1});
    this.save({vote: -1}, {url: url});
  },

  neutral: function(){
    var url = '/items/' + this.get('_id') + '/vote';
    this.set({vote: 0});
    this.save({vote: 0}, {url: url});
  }

});
