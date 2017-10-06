class Api::V1::SessionsController < Api::V1::BaseController
  before_action :is_authenticated, only: [:destroy]
  # before_action :check_device_token, only: [:create]
  # before_action :check_device_type, only: [:create, :destroy]
  # before_action :check_os_version, only: [:create, :destroy]
  swagger_controller :sessions, 'Sessions'

    swagger_api :create do
      param :query, :email, :string, :optional, "Email"
      param :query, :password, :string, :optional, "Password"
      response :unauthorized
      response :not_acceptable
    end

    swagger_api :social_login do |api|
      api.param :form, "user[email]", :string, :required, "Email"
      api.param :form, "user[first_name]", :string, :optional, "First Name"
      api.param :form, "user[last_name]", :string, :optional, "Last Name"
      api.param :form, "user[social_id]", :string, :required, "Social Id"
      api.param :form, "user[social_media]", :string, :required, "Social Media"

      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
      
    swagger_api :destroy do
      param :header, 'Authorization', :string, :required, 'API Token'
      response :ok
      response :not_found
      response :not_modified
    end

  def create
    @user = User.is_valid_user(params[:email], params[:password])
    if @user
      @user.update_attributes(:api_token => SecureRandom.uuid)
    else
      render :json => {:error => "Invalid Email/Password.", :success => false}, :status => 400
    end
  end

  def social_login
    if @user = User.find_by(email: params[:user][:email])
      # Just Login
      @user.update(user_params)
      @user.update_attributes(:api_token => SecureRandom.uuid)
    else
      # Create User
      if params[:user][:social_id].present? and params[:user][:social_media].present?
        random_password = ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(8).join
        puts random_password
        params[:user][:password] = random_password
      end
      @user = User.create(user_params)
      if @user.valid?
          @user.update_attributes(:api_token => SecureRandom.uuid)
          UserMailer.welcome(@user.email, random_password).deliver
      else
        render :json =>{:success => false, :error => "#{@user.errors.full_messages}"}, :status => 400
      end
    end
  end

  def destroy
    if  @user
      @user.update_attributes(:api_token => nil)
      render :json => {:success => true, :info => "Logged out"}, :status => 200
    else
      render :json => {:success => false, :error => "Your session expired. Please sign in again to continue."}, :status => 401
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :first_name, :last_name, :email,  :password, :password_confirmation, :social_id, :social_media)
  end

  def check_device_token
    render :json => {:error => "Device Token in not present"}, :status => 400 if params[:device_token].blank?
  end

  def check_device_type
    return @device_type = params[:device_type] if params[:device_type].present? and params[:device_type].in? ["android", "ios"]
    render :json => {:error => "Invalid Device Type"}, :status => 400
  end

  def check_os_version
    return @os_version = params[:os_version] if params[:os_version].present?
    render :json => {:error => "OS version is not present"}, :status => 400
  end

end
