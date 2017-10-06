class Admin::BarsController < AdminController
  load_and_authorize_resource  param_method: :admin_bar_params
  before_action :set_admin_bar, only: [:show, :edit, :update, :destroy]
  # GET /admin/bars
  # GET /admin/bars.json
  def index
    @admin_bars = Bar.all.page(params[:page])
    @q = @admin_bars.ransack(params[:q])
    @admin_bars = @q.result
  end

  # GET /admin/bars/1
  # GET /admin/bars/1.json
  def show
  end

  # GET /admin/bars/new
  def new
    days = Bar::DAYS
    @admin_bar = Bar.new
    @admin_bar.build_menu
    7.times.each do |index|
      @admin_bar.timings.build(day: days[index])
    end
    @admin_bar.business_infos.build
  end

  # GET /admin/bars/1/edit
  def edit
    @admin_bar.timings.build if @admin_bar.timings.blank?
  end

  # POST /admin/bars
  # POST /admin/bars.json
  def create
    @admin_bar = Bar.new(admin_bar_params)

    respond_to do |format|
      if @admin_bar.save
        format.html { redirect_to admin_bar_path(@admin_bar), notice: 'Bar was successfully created.' }
        format.json { render :show, status: :created, location: @admin_bar }
      else
        format.html { render :new }
        format.json { render json: @admin_bar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/bars/1
  # PATCH/PUT /admin/bars/1.json
  def update
    respond_to do |format|
      if @admin_bar.update(admin_bar_params)
        format.html { redirect_to admin_bar_path(@admin_bar), notice: 'Bar was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_bar }
      else
        format.html { render :edit }
        format.json { render json: @admin_bar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/bars/1
  # DELETE /admin/bars/1.json
  def destroy
    @admin_bar.destroy
    respond_to do |format|
      format.html { redirect_to admin_bars_url, notice: 'Bar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_bar
      @admin_bar = Bar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_bar_params
      file_params = [:file, :parent_id, :token, :role, :parent_type, file: []]

      params.fetch(:bar).permit(:name, :description, :address, :contact_no, :website, :ratings, 
        :price_range, category_ids: [], user_ids: [], attachments: [bar_photos: file_params], :timings_attributes => 
        [:id, :day, :opening_time, :closing_time, :_destroy], :business_infos_attributes => 
        [:id, :name, :value, :_destroy], :menu_attributes=>
        [:id, :description, :_destroy])
    end
end
