module VotesToColor
  def votes_to_color(args = {})
    thumbs_up = args[:thumbs_up] || 0
    thumbs_down = args[:thumbs_down] || 0
    neutral = args[:neutral] || 0
    use_default_color = args[:use_default_color] || false

    if use_default_color
      return OURVOYCE_CONFIG['default_graph_color']
    end

    if thumbs_up >= neutral && thumbs_up >= thumbs_down
      return OURVOYCE_CONFIG['thumbs_up_color']
    elsif thumbs_down >= neutral
      return OURVOYCE_CONFIG['thumbs_down_color']
    else
      return OURVOYCE_CONFIG['neutral_color']
    end


    #score = 100 * thumbs_up / (thumbs_up + thumbs_down) rescue 50
    #if(score > 66)
      #return "57B70E"
    #elsif(score < 33)
      #return "CB2C1E"
    #else
      #return "F08127"
    #end
  end
end
