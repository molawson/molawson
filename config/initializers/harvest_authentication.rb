if !ENV['HARVEST_USERNAME'] && !ENV['HARVEST_PASSWORD'] && !ENV['HARVEST_SUBDOMAIN']
  raw_config = File.read(Rails.root + "config/harvest_login.yml")
  HARVEST_LOGIN = YAML.load(raw_config)
else
  HARVEST_LOGIN = {'USERNAME' => ENV['HARVEST_USERNAME'], 'PASSWORD' => ENV['HARVEST_PASSWORD'], 'SUBDOMAIN' => ENV['HARVEST_SUBDOMAIN']}
end