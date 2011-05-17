require 'bundler'
require 'bundler/setup'




require 'dm-core'
require 'dm-mysql-adapter'
require 'dm-migrations'
require 'dm-validations'

require 'extlib'
#

env = ENV["RACK_ENV"] || "development"

user = "" 

if env == "production"
  pass = File.read(File.expand_path "~/.password").strip
  user = "root:#{pass}@" 
end

DataMapper.setup :default, "mysql://#{user}localhost/handsonxp_#{env}"
# 
# 
# Dir.glob("#{APP_PATH}/models/*").each do |model|
#   require model
# end

require 'voidtools'
include Voidtools::Sinatra::ViewHelpers