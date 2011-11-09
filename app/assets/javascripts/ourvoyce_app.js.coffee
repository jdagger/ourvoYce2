window.OurvoyceApp =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (base_url, vote_count, tag_friendly_name, tag_path, filter, sort_name, sort_direction, popular_tags, hot_topic_tags, items, item_ids, authenticated) ->
    this.authenticated = authenticated

    this.popular_tags = new PopularTags(popular_tags)
    this.hot_topic_tags = new HotTopicTags(hot_topic_tags)



    #this.items = new Items(items, [{tag_friendly_name: tag_friendly_name, tag_path: tag_path}])
    this.items = new Items(items, {base_url: base_url, tag_friendly_name: tag_friendly_name, tag_path: tag_path, filter: filter, sort_name: sort_name, sort_direction: sort_direction})
    this.item_ids = item_ids

    this.user_vote_count = new UserVoteCount({user_vote_count: vote_count})
    this.user_vote_count_view = new UserVoteCountView({model: this.user_vote_count})
    #this.current_tag = new CurrentTag({friendly_name: tag_friendly_name})

    this.details = new Detail()

    this.router = new OurvoyceRouter()

    this.itemsView = new ItemsView({collection: OurvoyceApp.items})
    this.itemsView.render()

    this.popularTagsView = new PopularTagsView({collection: OurvoyceApp.popular_tags})
    this.hotTopicTagsView = new HotTopicTagsView({collection: OurvoyceApp.hot_topic_tags})

    this.recordCounterView = new RecordCounterView({collection: OurvoyceApp.items})
    this.recordCounterView.render()


    this.filterView = new FilterView()
    this.filterView.render()

    this.currentTagView = new CurrentTagView({collection: OurvoyceApp.items})
    this.currentTagView.render()

    this.detailView = new DetailView({model: OurvoyceApp.details})

    Backbone.history.start({pushState: true, silent: true})
    return

$ ->
  $(window).scroll(() ->
    if($(window).scrollTop() == $(document).height() - $(window).height())
      window.OurvoyceApp.items.fetch_next()
    return
  )
