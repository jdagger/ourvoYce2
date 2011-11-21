class SearchesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:lookup, :autocomplete]
  
  def lookup
    search_term = params[:search].strip

    record = Tag.by_friendly_name(search_term).first

    unless record.nil?
      redirect_to tag_path(record.path)
    end
  end

  def autocomplete
    results = Tag.do_search(params[:term]).to_json
    Rails.logger.error results.inspect
    render :json => results
  end
end
