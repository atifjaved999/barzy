class Admin::AttachmentsController < AdminController

  def destroy
    @attachment = Attachment.find_by!(token: params[:id])
    @boat = @attachment.parent
    @attachment.destroy
    respond_to do |wants|
    	wants.js {}
      wants.html { redirect_to request.referer, notice: "Attachment has been removed Successfully."}
      wants.json { render status: 'complete' }
    end
  end

end
