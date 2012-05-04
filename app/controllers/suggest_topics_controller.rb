class SuggestTopicsController < ApplicationController

  def submit
    suggestion = params[:suggestion] || ''

    unless suggestion.blank?
      SuggestTopic.create do |st|
        st.topic =  suggestion
        st.user = current_user || nil
      end
    end


    respond_to do |format|
      format.json { render :json => {status: true}.to_json }
    end
  end
end
