class ApplicationController < ActionController::Base
  protect_from_forgery

  private #--------------------

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ADMIN_LOGIN['USERNAME'] && password == ADMIN_LOGIN['PASSWORD']
    end
  end
end
