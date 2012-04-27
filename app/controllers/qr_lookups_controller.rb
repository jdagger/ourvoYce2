class QrLookupsController < ApplicationController

  def index
    qr = QrLookup.where(:code => params[:id]).first
  end

end
