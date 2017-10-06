class Api::V1::CategoriesController < Api::V1::BaseController
    before_action :is_authenticated

  # ==================================Swagger Start=============================== #
    swagger_controller :categories, 'categories'
    swagger_api :index do
      summary 'Returns All Categories'
      param :header, 'Authorization', :string, :required, 'API Token'
      response :unauthorized
      response :not_acceptable, "The request you made is not acceptable"
      response :requested_range_not_satisfiable
    end

    swagger_api :show do
      summary "Fetches a single Category"
      param :header, 'Authorization', :string, :required, 'API Token'
      param :path, :id, :integer, :required, "Category Id"
      response :ok, "Success", :category
      response :unauthorized
      response :not_acceptable, "The request you made is not acceptable"
      response :not_found
    end
  # ==================================Swagger End================================= #

    def index
      @categories = Category.all
      if @categories.blank?
        render :json =>{ :success => false, :info=> "No Categories Found"}, :status => 400
      end
    end

    def show
      @category = Category.find_by_id(params[:id])

      if @category.blank?
        render :json =>{ :success => false, :info=> "No Category Found"}, :status => 400
      end
    end
end
