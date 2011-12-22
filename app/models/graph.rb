class Graph
  class << self
    include VotesToColor
    def build_national_age_graph(item_id)
      records = Stat.select("birth_year, sum(thumbs_up_vote_count) as thumbs_up_vote_count, sum(thumbs_down_vote_count) as thumbs_down_vote_count, sum(neutral_vote_count) as neutral_vote_count").where(item_id: item_id).group(:birth_year)
      buckets = get_buckets

      records.each do |record|
        buckets.each do |bucket|
          if(bucket[:range].include?(Time.now.year - record[:birth_year]))
            bucket[:thumbs_up_vote_count] = bucket[:thumbs_up_vote_count] + record.thumbs_up_vote_count
            bucket[:thumbs_down_vote_count] = bucket[:thumbs_down_vote_count] + record.thumbs_down_vote_count
            bucket[:neutral_vote_count] = bucket[:neutral_vote_count] + record.neutral_vote_count
          end
        end
      end

      build_results_from_buckets(buckets)
      return @scale_top, @ages
    end

    def build_state_age_graph(item_id, state)
      state_stat = Stat.select('birth_year, sum(thumbs_up_vote_count) as thumbs_up_vote_count, sum(thumbs_down_vote_count) as thumbs_down_vote_count, sum(neutral_vote_count) as neutral_vote_count').where(item_id: item_id, state: state.downcase).group(:birth_year)
      buckets = get_buckets
      state_stat.each do |stat|
        buckets.each do |bucket|
          if(bucket[:range].include?(Time.now.year - stat.birth_year))
            bucket[:thumbs_up_vote_count] = bucket[:thumbs_up_vote_count] + stat.thumbs_up_vote_count
            bucket[:thumbs_down_vote_count] = bucket[:thumbs_down_vote_count] + stat.thumbs_down_vote_count
            bucket[:neutral_vote_count] = bucket[:neutral_vote_count] + stat.neutral_vote_count
          end
        end
      end

      build_results_from_buckets(buckets)
      return @scale_top, @ages
    end

    def get_buckets
      [{range: (13..19) , label: '13-19', thumbs_up_vote_count: 0, neutral_vote_count: 0, thumbs_down_vote_count: 0}, 
       {range: (20..29) , label: '20-29', thumbs_up_vote_count: 0, neutral_vote_count: 0, thumbs_down_vote_count: 0}, 
       {range: (30..39) , label: '30-39', thumbs_up_vote_count: 0, neutral_vote_count: 0, thumbs_down_vote_count: 0}, 
       {range: (40..49) , label: '40-49', thumbs_up_vote_count: 0, neutral_vote_count: 0, thumbs_down_vote_count: 0}, 
       {range: (50..59) , label: '50-59', thumbs_up_vote_count: 0, neutral_vote_count: 0, thumbs_down_vote_count: 0}, 
       {range: (60..69) , label: '60-69', thumbs_up_vote_count: 0, neutral_vote_count: 0, thumbs_down_vote_count: 0}, 
       {range: (70..79) , label: '70-79', thumbs_up_vote_count: 0, neutral_vote_count: 0, thumbs_down_vote_count: 0}, 
       {range: (80..110), label: '80+', thumbs_up_vote_count: 0,   neutral_vote_count: 0, thumbs_down_vote_count: 0}]
    end

    def build_results_from_buckets(buckets)
      @scale_top = [1, buckets.collect{ |x| x[:thumbs_up_vote_count] + x[:neutral_vote_count] + x[:thumbs_down_vote_count]}.max].max

      #Make sure all horizontal bars(4) in graph have a value
      #If scale_top is 1 or 2, don't increase to multiple of four
      if (@scale_top > 2) && (@scale_top % 4 != 0)
        @scale_top = @scale_top + 4 - (@scale_top % 4)
      end

      buckets.each do |bucket|
        bucket[:scale] = (bucket[:thumbs_up_vote_count] + bucket[:thumbs_down_vote_count] + bucket[:neutral_vote_count]).to_f / @scale_top rescue 0
        score = (bucket[:thumbs_up_vote_count] / (bucket[:thumbs_up_vote_count] + bucket[:thumbs_down_vote_count])) * 100 rescue 0
        bucket[:color] = votes_to_color(bucket[:thumbs_up_vote_count], bucket[:thumbs_down_vote_count], bucket[:neutral_vote_count])
      end

      @ages = buckets
    end
  end
end
