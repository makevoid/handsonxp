path = File.expand_path "../", __FILE__

use Rack::Static, :root => "#{path}/public"

require "#{path}/handsonxp"
run Handsonxp