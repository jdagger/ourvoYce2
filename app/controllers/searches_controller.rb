class SearchesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:lookup, :autocomplete]
  
  def lookup
    search_term = params[:search].strip

    record = Tag.by_friendly_name(search_term).first

    if record.nil?
      redirect_to not_found_path(search_term)
    else
      #redirect_to tag_path(record.path)
      redirect_to "/ov/#!/tag/#{record.path}"
    end
  end

  def not_found
    @term = params[:term]
    @suggestions = Tag.do_search(params[:term])
  end

  def autocomplete
    results = Tag.do_search(params[:term]).to_json
    #Rails.logger.error results.inspect
    render :json => results
  end
end
