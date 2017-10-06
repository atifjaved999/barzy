class Api::V1::UsersController < Api::V1::BaseController
  before_action :is_authenticated, :only => [:index, :destroy, :reset_password, :email_exists, :favourite_bars, :update]
  before_action :check_current_user, :only => [:update]
  swagger_controller :users, "Users"

  swagger_api :index do
    param :header, 'Authorization', :string, :required, 'API Token'
    response :unauthorized
    response :not_acceptable
    response :requested_range_not_satisfiable
  end
  
  swagger_api :create do |api|
    api.param :form, "user[email]", :string, :required, "Email"
    api.param :form, "user[first_name]", :string, :required, "First Name"
    api.param :form, "user[last_name]", :string, :required, "Last Name"

    api.param :form, "user[password]", :string, :required, "Password"
    api.param :form, "user[password_confirmation]", :string, :required, "Password Confirmation"
    response :unauthorized
    response :not_acceptable
    response :requested_range_not_satisfiable
  end
      
  swagger_api :update do |api|
    api.param :header, 'Authorization', :string, :required, 'API Token'
    api.param :path, :id, :integer, :required, "User Id"
    api.param :form, "user[first_name]", :string, :required, "First Name"
    api.param :form, "user[last_name]", :string, :required, "Last Name"

    api.param :form, "user[current_password]", :string, :optional, "Current Password"
    api.param :form, "user[password]", :string, :optional, "Password"
    api.param :form, "user[password_confirmation]", :optional, "Password Confirmation"
    response :unauthorized
    response :not_acceptable
    response :requested_range_not_satisfiable
  end
      
  swagger_api :destroy do
    param :header, 'Authorization', :string, :required, 'API Token'
    response :unauthorized
    response :not_acceptable
    response :requested_range_not_satisfiable
  end
  swagger_api :forgot_password do
    param :query, :email, :string, :required, "Email"
    response :unauthorized
    response :not_acceptable
    response :requested_range_not_satisfiable
  end
  swagger_api :reset_password do
    param :header, 'Authorization', :string, :required, 'API Token'
    param :query, :password, :string, :required, "Password"
    param :query, :password_confirmation, :string, :required, "Password Confirmation"
    response :unauthorized
    response :not_acceptable
    response :requested_range_not_satisfiable
  end

  swagger_api :email_exists do
    param :header, 'Authorization', :string, :required, 'API Token'
    param :query, :email, :string, :required, "Email"
    response :unauthorized
    response :not_acceptable
    response :requested_range_not_satisfiable
  end

  swagger_api :favourite_bars do
    summary 'Returns Favourite_ bars'
    param :header, 'Authorization', :string, :required, 'API Token'
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end


  swagger_api :destroy do
    param :header, 'Authorization', :string, :required, 'API Token'
    response :ok
    response :not_found
    response :not_modified
    end

  def index
    @users = User.all.order(:id => :desc)
    if @users.empty?
      render :json =>{:success => false, :error => "No user Found"}, :status => 400
    end
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
        @user.role = 'User'
        @user.api_token = SecureRandom.uuid
        @user.save!
    else
      render :json =>{:success => false, :error => "#{@user.errors.full_messages}"}, :status => 400
    end 
  end

  # POST /users/forgot_password
  # Sends reset password instructions to provided email address.
  def forgot_password
    if params[:email]
      @user = User.find_by_email(params[:email].downcase)
      if @user
        @user.send_reset_password_instructions
          render :json =>{:success => true, :info=> "Reset password instructions email has been sent."}
      else
        # raise ActiveRecord::RecordNotFound
        render :json =>{:success => false, :error => "Email Not Found"
        } 
      end
    else
      render :json => {:success => false, :error => "Invalid Email/Password."}, :status => 400
    end
  end

  # POST /users/reset_password
  # Updates user password.
  def reset_password
    @user = current_user
    raise ActiveRecord::RecordNotFound if not @user.present?
    if @user
      @user.update_attributes(:password => params[:password], :password_confirmation => params[:password_confirmation])
      
      render :json =>{:success => true}
    else
      render :json => {:success => false}, :status => 400
    end
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user and params[:user][:password].present? and params[:user][:password_confirmation].present?
    
      unless User.find_by_email(@user.email).valid_password?(params[:user][:current_password])
        return render :json => {:success => false, :error => "Your current password is not valid"}, :status => 400
      end

      if User.find_by_email(@user.email).valid_password?(params[:user][:password])
        return render :json => {:success => false, :error => "Your current password must not be equal to old password"}, :status => 400
      end

      @user.update(user_params)
    else
      unless @user.update(user_params) and @user
        render :json => {:success => false, :error => "User has not been updated"}, :status => 400
      end
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])
    if @user
      @user.destroy
      render :json =>{:success => true}, :status => 200
    else
      render :json =>{:success => false}, :status => 400
    end
  end

  def email_exists
    @user = User.find_by_email(params[:email])
    if @user.blank?
      render :json => {:success => false, :error => "User Not Found."}, :status => 400
    end
    
  end

  def favourite_bars
    @favourite_bars = @user.bars
    if @favourite_bars.blank?
      render :json => {:success => false, :error => "No Favourite Bars Found."}, :status => 400
    end
  end

  private

  def check_current_user
    render :json => {:error => "You cannot update any other user"}, :status => 400 if @user.api_token != User.find_by_id(params[:id]).try(:api_token)
  end

  def user_params
    params.require(:user).permit(:id, :first_name, :last_name, :email,  :password, :password_confirmation)
  end

end



