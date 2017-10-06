class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_login

  rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        format.json { head :forbidden, content_type: 'text/html' }
        format.html { redirect_to admin_index_path, notice: exception.message }
        format.js   { head :forbidden, content_type: 'text/html' }
      end
    end

  def index
    category_bars = Category.joins(:bars).group("categories.name").count
    @category_bars_hash = Hash[category_bars.sort_by{|k, v| v}.reverse].first(12)

    top_admins = User.admins.joins(:bars).group("users.id").count
    @top_admins_hash = Hash[top_admins.sort_by{|k, v| v}.reverse].first(5)

    bar_users = Bar.joins(:users).where(users: {role: "User"}).group("bars.name").count
    @top_favourites_hash = Hash[bar_users.sort_by{|k, v| v}.reverse].first(12)

  end

  def check_login
    unless current_user.is?("Super Admin") || current_user.is?("Admin")
        sign_out
        redirect_to root_path
      end
  end

end
