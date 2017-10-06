class Admin::NeedHelpsController < AdminController
  before_action :set_admin_need_help, only: [:show, :destroy]

  # GET /admin/need_helps
  # GET /admin/need_helps.json
  def index
    @admin_need_helps = NeedHelp.all
  end

  # GET /admin/need_helps/1
  # GET /admin/need_helps/1.json
  def show
  end

  # GET /admin/need_helps/new
  def new
    @admin_need_help = NeedHelp.new
  end

  def destroy
    @admin_need_help.destroy
    respond_to do |format|
      format.html { redirect_to admin_need_helps_url, notice: 'Need Help was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_need_help
      @admin_need_help = NeedHelp.find(params[:id])
    end
end
