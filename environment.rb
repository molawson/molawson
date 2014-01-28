$:.unshift File.dirname(__FILE__) + '/lib'

require 'json'
require 'uri'

require 'redis'

uri = URI.parse(
  ENV['REDISCLOUD_URL'] ||
  ENV['REDISTOGO_URL'] ||
  'redis://127.0.0.1:6379'
)
$redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
