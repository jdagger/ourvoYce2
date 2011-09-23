class ItemsController < ApplicationController
  include Items::LoadItems
  def vote
    item_id = params[:item_id]
    user_id = current_user.id
    vote = params[:new_vote]
    #TODO: validate vote/item_id/check user_id (through authentication requirement)

    Vote.record_vote(current_user.id, current_user.state, current_user.zip, current_user.latitude, current_user.longitude, current_user.birth_year, item_id, vote)

    respond_to do |format|
      format.json { render :json => {success: 1}.to_json }
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
    state_zip_stat = StateZipStat.where(:item_id => params[:item_id], :state => state).first

    #Had problems iterating the state_zip_stat zip collection, so converting to json first


    @zips = []
    max = 1
    state_zip_stat["zips"].each do |key, value|
      tu = value["vote"]["thumbs_up_count"] || 0
      td = value["vote"]["thumbs_down_count"] || 0
      n = value["vote"]["neutral_count"] || 0

      @zips << {
        name: key,
        scale: 1.00,
        lat: value['latitude'],
        long: value['longitude'],
        color: votes_to_color(tu, td, n),
        thumbs_up_count: tu,
        thumbs_down_count: td,
        neutral_count: n,
        total_count: tu + td + n
      }
      max = [max, tu + td + n].max
    end

    @zips.each do |zip|
      zip[:scale] = zip[:total_count] / max
    end

    render :template => 'items/state_map'
  end

  def build_national_map
    national_state_stat = NationalStateStat.where(:item_id => params[:item_id])
    @states = []

    national_state_stat.each do |stat|
      tu = stat.vote.thumbs_up_count rescue 0
      td = stat.vote.thumbs_down_count rescue 0
      n = stat.vote.neutral_count rescue 0
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
    [{range: (13..19) , label: '13-19', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
     {range: (20..29) , label: '20-29', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
     {range: (30..39) , label: '30-39', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
     {range: (40..49) , label: '40-49', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
     {range: (50..59) , label: '50-59', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
     {range: (60..69) , label: '60-69', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
     {range: (70..79) , label: '70-79', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
     {range: (80..110), label: '80+', thumbs_up_count: 0,   neutral_count: 0, thumbs_down_count: 0}]

  end

  #refactor to model
  def build_national_age
    records = NationalYearStat.where(item_id: params[:item_id])
    buckets = get_buckets

    records.each do |record|
      buckets.each do |bucket|
        if(bucket[:range].include?(Time.now.year - record[:birth_year]))
          vote = record[:vote]
          unless vote.nil?
            bucket[:thumbs_up_count] = bucket[:thumbs_up_count] + record.vote.thumbs_up_count
            bucket[:thumbs_down_count] = bucket[:thumbs_down_count] + record.vote.thumbs_down_count
            bucket[:neutral_count] = bucket[:neutral_count] + record.vote.neutral_count
            break
          end
        end
      end
    end

    build_results_from_buckets(buckets)

  end

  def build_state_age
    state_stat = StateYearStat.where(item_id: params[:item_id], state: params[:state].downcase).first

    buckets = get_buckets


    (1900..2020).to_a.each do |year|
      unless state_stat.nil? || state_stat[year].nil?
        buckets.each do |bucket|
          if(bucket[:range].include?(Time.now.year - year))
            vote = state_stat[year.to_s]["vote"]
            unless vote.nil?
              unless vote["thumbs_up_count"].blank?
                bucket[:thumbs_up_count] = bucket[:thumbs_up_count] + vote["thumbs_up_count"] 
              end
              unless vote["thumbs_down_count"].blank?
                bucket[:thumbs_down_count] = bucket[:thumbs_down_count] + vote["thumbs_down_count"] 
              end
              unless vote["neutral_count"].blank?
                bucket[:neutral_count] = bucket[:neutral_count] + vote["neutral_count"] 
              end
              break
            end
          end
        end
      end
    end

    build_results_from_buckets(buckets)
  end

  def build_results_from_buckets(buckets)
    @results = {}
    @results[:max] = [1, buckets.collect{ |x| x[:thumbs_up_count] + x[:neutral_count] + x[:thumbs_down_count]}.max].max
    buckets.each do |bucket|
      bucket[:scale] = (bucket[:thumbs_up_count] + bucket[:thumbs_down_count] + bucket[:neutral_count]).to_f / @results[:max] rescue 0
      score = (bucket[:thumbs_up_count] / (bucket[:thumbs_up_count] + bucket[:thumbs_down_count])) * 100 rescue 0
      bucket[:color] = votes_to_color(bucket[:thumbs_up_count], bucket[:thumbs_down_count], bucket[:neutral_count])
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

  def keyword
    keyword = params[:keyword]

    load_items(keyword)

    respond_to do |format|
      format.html { render :text => @items.to_json }
      format.json { render :json => @items.to_json }
    end
  end
end
