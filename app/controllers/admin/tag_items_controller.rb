class Admin::TagItemsController < Admin::ApplicationController
  def destroy
    TagItem.delete(params[:id])
    redirect_to request.referrer, :notice => "Removed Tag"
  end
end
