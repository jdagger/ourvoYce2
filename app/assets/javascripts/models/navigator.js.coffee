@KeywordNavigate = (keyword, filter, sort) ->
  url = "k/#{keyword}"
  
  if filter? and filter.length > 0
    url += "/#{filter}"
    if sort? and sort.length > 0
      url += "/#{sort}"

  OurvoyceApp.router.navigate(url, true)
  return

