if !ENV['ADMIN_USERNAME'] && !ENV['ADMIN_PASSWORD']
  raw_config = File.read(Rails.root + "config/admin_login.yml")
  ADMIN_LOGIN = YAML.load(raw_config)
else
  ADMIN_LOGIN = {'USERNAME' => ENV['ADMIN_USERNAME'], 'PASSWORD' => ENV['ADMIN_PASSWORD']}
end