path = File.expand_path "../", __FILE__

namespace :db do

  desc ""
  task :seeds do
    require "#{path}/handsonxp"
    DataMapper.auto_migrate!
    require "#{path}/seeds"
  end
  
end