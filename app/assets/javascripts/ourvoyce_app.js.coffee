window.OurvoyceApp =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: (base_url, vote_count, tag_friendly_name, tag_path, filter, sort_name, sort_direction, popular_tags, hot_topic_tags, items, item_ids, authenticated, records_to_fetch, is_item) ->
    this.authenticated = authenticated

    this.popular_tags = new PopularTags(popular_tags)
    this.hot_topic_tags = new HotTopicTags(hot_topic_tags)
    
    this.detail = new Detail()
    this.items = new Items(items, {base_url: base_url, tag_friendly_name: tag_friendly_name, tag_path: tag_path, filter: filter, sort_name: sort_name, sort_direction: sort_direction, records_to_fetch: records_to_fetch, is_item: is_item})
    this.suggest_topics = new SuggestTopic()

    this.item_ids = item_ids

    this.user_vote_count = new UserVoteCount({user_vote_count: vote_count})

    this.user_vote_count_view = new UserVoteCountView({model: this.user_vote_count})
    this.itemsView = new ItemsView({collection: OurvoyceApp.items})
    this.detailView = new DetailView({model: OurvoyceApp.detail})
    this.popularTagsView = new PopularTagsView({collection: OurvoyceApp.popular_tags})
    this.hotTopicTagsView = new HotTopicTagsView({collection: OurvoyceApp.hot_topic_tags})
    this.recordCounterView = new RecordCounterView({collection: OurvoyceApp.items})
    this.filterView = new FilterView()
    this.currentTagView = new CurrentTagView({collection: OurvoyceApp.items})

    this.suggestTopicView = new SuggestTopicView({model: this.suggest_topics})


    this.router = new OurvoyceRouter()

    Backbone.history.start({pushState: false, silent: false})

    return

  selected_option: (val, left) ->
    if(val == left)
      return "selected"
    else
      return ""


window.preload = (arrayOfImages) ->
  _.each(arrayOfImages, (element) ->
    $('<img/>')[0].src = element
  )
  return

preload(['/assets/site/ajax-loader.gif'])

$ ->
  return
