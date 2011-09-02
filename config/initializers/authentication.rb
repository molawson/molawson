raw_config = File.read(Rails.root + "config/auth_credentials.yml")
credentials = YAML.load(raw_config)

if !ENV['ADMIN_USERNAME'] && !ENV['ADMIN_PASSWORD']
  ADMIN_AUTH = credentials['admin']
else
  ADMIN_AUTH = {'USERNAME' => ENV['ADMIN_USERNAME'], 'PASSWORD' => ENV['ADMIN_PASSWORD']}
end

if !ENV['HARVEST_USERNAME'] && !ENV['HARVEST_PASSWORD'] && !ENV['HARVEST_SUBDOMAIN']
  HARVEST_AUTH = credentials['harvest']
else
  HARVEST_AUTH = {'USERNAME' => ENV['HARVEST_USERNAME'], 'PASSWORD' => ENV['HARVEST_PASSWORD'], 'SUBDOMAIN' => ENV['HARVEST_SUBDOMAIN']}
end

if !ENV['STRIPE_API_KEY']
  STRIPE_AUTH = credentials['stripe']
else
  STRIPE_AUTH = {'API_KEY' => ENV['STRIPE_API_KEY']}
end