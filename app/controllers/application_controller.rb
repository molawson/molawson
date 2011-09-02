class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private #--------------------
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ADMIN_AUTH['USERNAME'] && password == ADMIN_AUTH['PASSWORD']
    end
  end
  
  def load_harvest
    @harvest = Harvest.hardy_client(HARVEST_AUTH['SUBDOMAIN'], HARVEST_AUTH['USERNAME'], HARVEST_AUTH['PASSWORD'])
  end
end
