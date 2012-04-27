class QrLookupsController < ApplicationController

  def index
    qr = QrLookup.where(:code => params[:id]).first
    unless qr.nil?
      qr.counter += 1
      qr.save

      redirect_to qr.destination unless qr.destination.blank?
    end
  end

end
