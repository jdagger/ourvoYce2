class Map
  class << self
    include VotesToColor

    def build_national_vote_map(item_id)
      national_state_stat = Stat.select("sum(thumbs_up_vote_count) as thumbs_up_vote_count, sum(thumbs_down_vote_count) as thumbs_down_vote_count, sum(neutral_vote_count) as neutral_vote_count, state").where(item_id: item_id).group(:state)
      @states = []

      national_state_stat.each do |stat|
        tu = stat.thumbs_up_vote_count rescue 0
        td = stat.thumbs_down_vote_count rescue 0
        n = stat.neutral_vote_count rescue 0
        color = votes_to_color(thumbs_up: tu, thumbs_down: td, neutral: n) 

        if ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'].include?(stat[:state].upcase)
          @states << {name: stat[:state], color: color}
        end
      end
      return @states
    end

    def build_state_vote_map(item_id, state)
      state = state.downcase
      state_zip_stat = Stat.joins("join zips on zips.zip=stats.zip").select("zips.zip as zip, zips.latitude as latitude, zips.longitude as longitude, sum(thumbs_up_vote_count) as thumbs_up_vote_count, sum(thumbs_down_vote_count) as thumbs_down_vote_count, sum(neutral_vote_count) as neutral_vote_count").where(item_id: item_id, state: state).group("zips.zip, zips.latitude, zips.longitude")

      @zips = []
      max = 1
      unless state_zip_stat.nil?
        state_zip_stat.each do |stat|
          tu = stat.thumbs_up_vote_count
          td = stat.thumbs_down_vote_count
          n = stat.neutral_vote_count

          @zips << {
            name: stat['zip'],
            scale: 1.00,
            lat: stat.latitude,
            long: stat.longitude,
            color: votes_to_color(thumbs_up: tu, thumbs_down: td, neutral: n),
            thumbs_up_vote_count: tu,
            thumbs_down_vote_count: td,
            neutral_vote_count: n,
            total_vote_count: tu + td + n
          }
          max = [max, tu + td + n].max
        end
      end

      @zips.each do |zip|
        zip[:scale] = zip[:total_vote_count] / max
      end

      return @zips
    end

  end
end
