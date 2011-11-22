@Navigate = (base_url, argument, filter, sort_name, sort_direction) ->
  if base_url? && base_url.length > 0
    url = "#{base_url}"

  if argument? && argument.length > 0
    if url.length > 0
      url += "/"
    url += argument
  
  if filter? and filter.length > 0
    url += "/#{filter}"
    if sort_name? and sort_name.length > 0 and sort_direction? and sort_direction.length > 0 
      url += "/#{sort_name}:#{sort_direction}"

  OurvoyceApp.router.navigate(url, true)
  return

