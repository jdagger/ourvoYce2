class GraphsController < ApplicationController
  def national_age_graph
    @scale_top, @ages = Graph.build_national_age_graph(params[:item_id])
    render 'age'
  end


  def state_age_graph
    @scale_top, @ages = Graph.build_state_age_graph(params[:item_id], params[:state])
    render 'age'
  end
end
