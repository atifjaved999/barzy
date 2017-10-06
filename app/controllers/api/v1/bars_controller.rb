class Api::V1::BarsController < Api::V1::BaseController
  before_action :is_authenticated

# ==================================Swagger Start=============================== #
  swagger_controller :bars, 'bars'
  swagger_api :index do
    summary 'Returns All bars'
    param :header, 'Authorization', :string, :required, 'API Token'
    param :query, :page, :string, :optional, "Page No"
    param :query, :category_id, :string, :optional, "Category Id"
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :search do
    summary "Fetches a Searched Bars"
    param :header, 'Authorization', :string, :required, 'API Token'
    param :query, :page, :string, :optional, "Page No"
    param :query, :bar_name, :string, :required, "Bar Name"
    response :ok, "Success", :bar
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :not_found
  end

  swagger_api :show do
    summary "Fetches a single bar"
    param :header, 'Authorization', :string, :required, 'API Token'
    param :path, :id, :integer, :required, "bar Id"
    response :ok, "Success", :bar
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :not_found
  end

  swagger_api :add_favourite do
    summary "Add Favourite Bar"
    param :header, 'Authorization', :string, :required, 'API Token'
    param :path, :id, :integer, :required, "bar Id"
    response :ok, "Success", :bar
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :not_found
  end

  swagger_api :remove_favourite do
    summary "Remove Favourite Bar"
    param :header, 'Authorization', :string, :required, 'API Token'
    param :path, :id, :integer, :required, "bar Id"
    response :ok, "Success", :bar
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :not_found
  end
# ==================================Swagger End================================= #

  def index
    if category = Category.find_by_id(params[:category_id])
    @bars =  category.bars
    else
    @bars = Bar.all
    end
    page_no = params[:page] ? params[:page] : 1
    @bars = @bars.page(page_no)

    if @bars.blank?
      render :json =>{ :success => false, :info=> "No Bars Found"}, :status => 400
    end
  end

  def search
    if params[:bar_name].present?
      @bars = Bar.where("LOWER(bars.name) LIKE ?" , "%#{params[:bar_name].squish}%".downcase)
    end
    page_no = params[:page] ? params[:page] : 1
    @bars = @bars.page(page_no)
    if @bars.blank?
      render :json =>{ :success => false, :info=> "No Bars Found"}, :status => 400
    end
  end

  def show
    @bar = Bar.find_by_id(params[:id])

    if @bar.blank?
      render :json =>{ :success => false, :info=> "No Bar Found"}, :status => 400
    end
  end

  def add_favourite
      if bar = Bar.find_by_id(params[:id])
        if BarUser.find_by(bar_id: bar.id, user_id: @user.id)
          render :json =>{ :success => false, :info=> "This Bar has already been added to your favourites"}, :status => 400
        else
          BarUser.create(bar_id: bar.id, user_id: @user.id)
          render :json =>{ :success => true, :info=> "This Bar has been added to your favourites"}, :status => 200
        end
      else
        render :json =>{ :success => false, :info=> "No Bar Found"}, :status => 400
      end
  end

  def remove_favourite
    if bar_user = BarUser.find_by(bar_id: params[:id], user_id: @user.id)
      bar_user.destroy
      render :json =>{ :success => true, :info=> "This Bar has been removed to your favourites"}, :status => 200
    else
      render :json =>{ :success => false, :info=> "No favourite found"}, :status => 400
    end
  end

end
