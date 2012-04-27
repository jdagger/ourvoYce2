class Admin::QrLookupsController < Admin::ApplicationController
  def index
    page = params[:page] || 1
    sort_column = params[:c]
    sort_direction = params[:d] == "up" ? "asc" : "desc"

    @qr_lookups = QrLookup.paginate(:page => page, :per_page => 50)

    unless sort_column.blank?
      @qr_lookups = @qr_lookups.order("#{sort_column} #{sort_direction}")
    end
  end

  def show 
    @qr_lookup = QrLookup.find(params[:id])
  end

  def new
    @qr_lookup = QrLookup.new
  end

  def create
    @qr_lookup = QrLookup.new do |qr_lookup|
      qr_lookup.code = params[:qr_lookup][:code]
      qr_lookup.destination = params[:qr_lookup][:destination]
      qr_lookup.notes = params[:qr_lookup][:notes]
    end

    if @qr_lookup.save
      flash[:success] = 'Successfully created QR lookup'
      redirect_to edit_admin_qr_lookup_path(@qr_lookup)
    else
      flash[:error] = 'Failed to create QR lookup'
      render :new
    end
  end

  def edit
    @qr_lookup = QrLookup.find(params[:id])
  end

  def update
    @qr_lookup = QrLookup.find(params[:id])
    @qr_lookup.code = params[:qr_lookup][:code]
    @qr_lookup.destination = params[:qr_lookup][:destination]
    @qr_lookup.notes = params[:qr_lookup][:notes]
    @qr_lookup.counter = params[:qr_lookup][:counter]

    if @qr_lookup.save
      flash[:success] = 'Successfully updated QR lookup'
    else
      flash[:error] = 'Failed to save QR lookup'
    end
    render :edit
  end

  def destroy
    QrLookup.delete(params[:id])
    flash[:success] = 'Successfully deleted QR lookup'
    redirect_to admin_qr_lookups_path
  end
end
