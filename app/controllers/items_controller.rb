class ItemsController < ApplicationController
  include Items::LoadItems
  def vote
    item_id = params[:item_id]
    user_id = current_user.id
    vote = params[:vote]
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
    national_state_stat = NationalStateStat.where(:item_id => params[:item_id])
    @states = []

    national_state_stat.each do |stat|
      tu = stat.vote.thumbs_up_count rescue 0
      td = stat.vote.thumbs_down_count rescue 0
      score = 100 * tu / (tu + td) rescue 50
      color = score_to_color(score)
      @states << {name: stat[:state], color: color}
    end

    render :template => 'items/national_map'
  end

  def age
    records = NationalYearStat.where(item_id: params[:item_id])
    buckets = [{range: (13..19) , label: '13-19', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
               {range: (20..29) , label: '20-29', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
               {range: (30..39) , label: '30-39', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
               {range: (40..49) , label: '40-49', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
               {range: (50..59) , label: '50-59', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
               {range: (60..69) , label: '60-69', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
               {range: (70..79) , label: '70-79', thumbs_up_count: 0, neutral_count: 0, thumbs_down_count: 0}, 
               {range: (80..110), label: '80+', thumbs_up_count: 0,   neutral_count: 0, thumbs_down_count: 0}]


    records.each do |record|
      buckets.each do |bucket|
        if(bucket[:range].include?(Time.now.year - record[:birth_year]))
          vote = record[:vote]
          unless vote.nil?
            bucket[:thumbs_up_count] += record.vote.thumbs_up_count
            bucket[:thumbs_down_count] += record.vote.thumbs_down_count
            bucket[:neutral_count] += record.vote.neutral_count
            break
          end
        end
      end
    end

   
    @results = {}
    @results[:max] = buckets.collect{ |x| x[:thumbs_up_count] + x[:neutral_count] + x[:thumbs_down_count]}.max

    buckets.each do |bucket|
      bucket[:scale] = (bucket[:thumbs_up_count] + bucket[:thumbs_down_count] + bucket[:neutral_count]) / @results[:max] rescue 0
      score = (bucket[:thumbs_up_count] / (bucket[:thumbs_up_count] + bucket[:thumbs_down_count])) * 100 rescue 0
      bucket[:color] = score_to_color(score)
    end

    @results[:ages] = buckets
  end

  def score_to_color(score)
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
