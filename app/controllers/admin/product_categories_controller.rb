class Admin::ProductCategoriesController < AdminController
  load_and_authorize_resource  param_method: :admin_product_category_params
  before_action :set_admin_product_category, only: [:show, :edit, :update, :destroy]

  # GET /admin/product_categories
  # GET /admin/product_categories.json
  def index
    @admin_product_categories = ProductCategory.all
  end

  # GET /admin/product_categories/1
  # GET /admin/product_categories/1.json
  def show
  end

  # GET /admin/product_categories/new
  def new
    @admin_product_category = ProductCategory.new
    @admin_product_category.products.build
  end

  # GET /admin/product_categories/1/edit
  def edit
  end

  # POST /admin/product_categories
  # POST /admin/product_categories.json
  def create
    @admin_product_category = ProductCategory.new(admin_product_category_params)

    respond_to do |format|
      if @admin_product_category.save
        format.html { redirect_to admin_bar_menu_path(@admin_product_category.menu.bar, @admin_product_category.menu), notice: 'Product category was successfully created.' }
        format.json { render :show, status: :created, location: @admin_product_category }
      else
        format.html { render :new }
        format.json { render json: @admin_product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/product_categories/1
  # PATCH/PUT /admin/product_categories/1.json
  def update
    respond_to do |format|
      if @admin_product_category.update(admin_product_category_params)
        format.html { redirect_to admin_bar_menu_path(@admin_product_category.menu.bar, @admin_product_category.menu), notice: 'Product category was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_product_category }
      else
        format.html { render :edit }
        format.json { render json: @admin_product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_categories/1
  # DELETE /admin/product_categories/1.json
  def destroy
    @admin_product_category.destroy
    respond_to do |format|
      format.html { redirect_to admin_bar_menu_path(@admin_product_category.menu.bar, @admin_product_category.menu), notice: 'Product category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_product_category
      @admin_product_category = ProductCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_product_category_params
      params[:product_category][:menu_id] = params[:menu_id] if params[:product_category].present?
      params.fetch(:product_category).permit(:name, :description, :menu_id, :products_attributes=>
        [:id, :name, :description, :product_category_id, :price, :_destroy])
    end
end
