@KeywordNavigate = (keyword, filter, sort_name, sort_direction) ->
  url = "k/#{keyword}"
  
  if filter? and filter.length > 0
    url += "/#{filter}"
    if sort_name? and sort_name.length > 0 and sort_direction? and sort_direction.length > 0 
      url += "/#{sort_name}:#{sort_direction}"

  OurvoyceApp.router.navigate(url, true)
  return

