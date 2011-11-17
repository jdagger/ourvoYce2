module VotesToColor
  def votes_to_color(thumbs_up, thumbs_down, neutral)
    thumbs_up = thumbs_up || 0
    thumbs_down = thumbs_down || 0
    neutral = neutral || 0

    score = 100 * thumbs_up / (thumbs_up + thumbs_down) rescue 50
    if(score > 66)
      return "57B70E"
    elsif(score < 33)
      return "CB2C1E"
    else
      return "F08127"
    end
  end
end
