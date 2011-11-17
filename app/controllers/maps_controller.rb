class MapsController < ApplicationController
  def national_vote_map
    @states = Map.build_national_vote_map(params[:item_id])
    render :template => 'maps/national_map'
  end

  def state_vote_map
    @zips = Map.build_state_vote_map(params[:item_id], params[:state])
    render :template => 'maps/state_map'
  end
end
