class Admin::MenusController < AdminController
  load_and_authorize_resource  param_method: :admin_menu_params
  before_action :set_admin_menu, only: [:show, :edit, :update, :destroy]

  # GET /admin/menus/1
  # GET /admin/menus/1.json
  def show
  end

  # GET /admin/menus/1/edit
  def edit
  end

  # PATCH/PUT /admin/menus/1
  # PATCH/PUT /admin/menus/1.json
  def update
    respond_to do |format|
      if @admin_menu.update(admin_menu_params)
        format.html { redirect_to admin_bar_menu_path(@admin_menu.bar, @admin_menu), notice: 'Menu was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_menu }
      else
        format.html { render :edit }
        format.json { render json: @admin_menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/menus/1
  # DELETE /admin/menus/1.json
  def destroy
    @admin_menu.destroy
    respond_to do |format|
      format.html { redirect_to admin_menus_url, notice: 'Menu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_menu
      @admin_menu = Menu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_menu_params
      file_params = [:file, :parent_id, :token, :role, :parent_type, file: []]
      params.fetch(:menu).permit(:id, :description, :bar_id,  attachment: [extra: file_params])
    end
end
