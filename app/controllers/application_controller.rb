class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private #--------------------
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ADMIN_LOGIN['USERNAME'] && password == ADMIN_LOGIN['PASSWORD']
    end
  end
  
  def load_harvest
    @harvest = Harvest.hardy_client(HARVEST_LOGIN['SUBDOMAIN'], HARVEST_LOGIN['USERNAME'], HARVEST_LOGIN['PASSWORD'])
  end
end
