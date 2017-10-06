class Api::V1::BaseController < ActionController::Base
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/vnd.radd.v1' }
  # protect_from_forgery with: :null_session
  respond_to :json

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Expose-Headers'] = 'Etag'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, PATCH, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = '*, x-requested-with, Content-Type, If-Modified-Since, If-None-Match'
    headers['Access-Control-Max-Age'] = '86400'
  end

  protected

  def is_authenticated
    authenticate_token || render_unauthenticated
  end

  def render_unauthenticated 
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: {:success => false, :info => "Un authorized"}, status: 401
  end


  def authenticate_token
    authenticate_with_http_token do |token, options|
      @user = User.find_by_api_token  token
    end
  end

end
