class ItemsController < ApplicationController
  include Items::LoadItems
  def vote
    item_id = params[:item_id]
    user_id = current_user.id
    vote = params[:new_vote]
    #TODO: validate vote/item_id/check user_id (through authentication requirement)

    Vote.record_vote(current_user.id, current_user.state, current_user.zip, current_user.birth_year, item_id, vote)

    respond_to do |format|
      format.json { render :json => {success: 1}.to_json }
    end
  end

  #Retrieve the items for the specified item_ids
  def fetch
    item_ids = params[:item_ids]

    load_items_by_id(item_ids)

    respond_to do |format|
      format.json { render :json => {:item_ids => @item_ids, :items => @items}.to_json}
    end

  end

  def keyword
    keyword = params[:keyword]
    filter = params[:filter]
    sort = params[:sort]

    load_items(keyword, filter, sort, current_user.id)

    respond_to do |format|
      format.json { render :json => {:item_ids => @item_ids, :items => @items, :keyword_friendly_name => @keyword_friendly_name, :keyword_path => @keyword_path, :filter => @filter, :sort_name => @sort_name, :sort_direction => @sort_direction}.to_json}
    end
  end


  def details
    item = Item.find(params[:item_id])
    respond_to do |format|
      format.json { render :json => item.to_json }
    end
  end

  def map
    if params[:state].blank?
      build_national_map
    else
      build_state_map
    end
  end

  def build_state_map
    state = params[:state].downcase
    state_zip_stat = Stat.joins("join zips on zips.zip=stats.zip").select("zips.zip as zip, zips.latitude as latitude, zips.longitude as longitude, sum(thumbs_up_vote_count) as thumbs_up_vote_count, sum(thumbs_down_vote_count) as thumbs_down_vote_count, sum(neutral_vote_count) as neutral_vote_count").where(item_id: params[:item_id], state: state).group("zips.zip, zips.latitude, zips.longitude")

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
          color: votes_to_color(tu, td, n),
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

    render :template => 'items/state_map'
  end

  def build_national_map
    national_state_stat = Stat.select("sum(thumbs_up_vote_count) as thumbs_up_vote_count, sum(thumbs_down_vote_count) as thumbs_down_vote_count, sum(neutral_vote_count) as neutral_vote_count, state").where(item_id: params[:item_id]).group(:state)
    @states = []

    national_state_stat.each do |stat|
      tu = stat.thumbs_up_vote_count rescue 0
      td = stat.thumbs_down_vote_count rescue 0
      n = stat.neutral_vote_count rescue 0
      color = votes_to_color(tu, td, n) 
      @states << {name: stat[:state], color: color}
    end

    render :template => 'items/national_map'

  end

  def age
    if params[:state].blank?
      build_national_age
    else
      build_state_age
    end


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

  #refactor to model
  def build_national_age
    #records = NationalYearStat.where(item_id: params[:item_id])
    records = Stat.select("birth_year, sum(thumbs_up_vote_count) as thumbs_up_vote_count, sum(thumbs_down_vote_count) as thumbs_down_vote_count, sum(neutral_vote_count) as neutral_vote_count").where(item_id: params[:item_id]).group(:birth_year)
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

  end

  def build_state_age
    #state_stat = StateYearStat.where(item_id: params[:item_id], state: params[:state].downcase).first
    state_stat = Stat.select('birth_year, sum(thumbs_up_vote_count) as thumbs_up_vote_count, sum(thumbs_down_vote_count) as thumbs_down_vote_count, sum(neutral_vote_count) as neutral_vote_count').where(item_id: params[:item_id], state: params[:state].downcase).group(:birth_year)


    buckets = get_buckets


    #(1900..2020).to_a.each do |year|
      #unless state_stat.nil? || state_stat[year].nil?
    state_stat.each do |stat|
        buckets.each do |bucket|
          if(bucket[:range].include?(Time.now.year - stat.birth_year))
            #vote = state_stat[year.to_s]["vote"]
            #unless vote.nil?
            #  unless vote["thumbs_up_vote_count"].blank?
                #bucket[:thumbs_up_vote_count] = bucket[:thumbs_up_vote_count] + vote["thumbs_up_vote_count"] 
                bucket[:thumbs_up_vote_count] = bucket[:thumbs_up_vote_count] + stat.thumbs_up_vote_count
            #  end
            #  unless vote["thumbs_down_vote_count"].blank?
                #bucket[:thumbs_down_vote_count] = bucket[:thumbs_down_vote_count] + vote["thumbs_down_vote_count"] 
                bucket[:thumbs_down_vote_count] = bucket[:thumbs_down_vote_count] + stat.thumbs_down_vote_count
            #  end
            #  unless vote["neutral_vote_count"].blank?
                #bucket[:neutral_vote_count] = bucket[:neutral_vote_count] + vote["neutral_vote_count"] 
                bucket[:neutral_vote_count] = bucket[:neutral_vote_count] + stat.neutral_vote_count
            #  end
            #  break
            #end
          end
        #end
      end
    end

    build_results_from_buckets(buckets)
  end

  def build_results_from_buckets(buckets)
    @results = {}
    @results[:max] = [1, buckets.collect{ |x| x[:thumbs_up_vote_count] + x[:neutral_vote_count] + x[:thumbs_down_vote_count]}.max].max
    buckets.each do |bucket|
      bucket[:scale] = (bucket[:thumbs_up_vote_count] + bucket[:thumbs_down_vote_count] + bucket[:neutral_vote_count]).to_f / @results[:max] rescue 0
      score = (bucket[:thumbs_up_vote_count] / (bucket[:thumbs_up_vote_count] + bucket[:thumbs_down_vote_count])) * 100 rescue 0
      bucket[:color] = votes_to_color(bucket[:thumbs_up_vote_count], bucket[:thumbs_down_vote_count], bucket[:neutral_vote_count])
    end

    @results[:ages] = buckets

  end

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
