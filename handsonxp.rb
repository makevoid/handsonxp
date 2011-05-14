require 'haml'
require 'sass'
require 'sinatra'
enable :sessions

path = File.expand_path "../", __FILE__
APP_PATH = path

require 'pony'
require "#{path}/lib/pony_gmail"


class String
  def titleize
    self.gsub(/\s+/, "_").downcase
  end
end

class Handsonxp < Sinatra::Base
  require "#{APP_PATH}/config/env"
  
  
  configure :development do # this way you can use thin, shotgun is so slow...
    use Rack::Reloader
    set :public, "public"
    set :static, true
  end
  
  set :haml, { :format => :html5 }
  require 'rack-flash'
  enable :sessions
  use Rack::Flash
  require 'sinatra/content_for'
  helpers Sinatra::ContentFor
  set :method_override, true
  
  require "#{APP_PATH}/lib/view_helpers"
  helpers ViewHelpers

  # require models
  require "#{APP_PATH}/models/creation"
  require "#{APP_PATH}/models/user"

  def not_found(object=nil)
    halt 404, "404 - Page Not Found"
  end
  
  helpers do
    def user
      @user ||= User.get(1) || User.new
    end
    
    def home?
      request.path == "/"
    end
  end
  
  get "/" do
    haml :index
  end
  
  get "/creations/index" do # aka get /creations
    haml :"creations/index"
  end
  
  get "/category/*" do |category|
    @category = category
  end
  
  get '/css/main.css' do
    sass :main
  end
  
  if ENV['RACK_ENV'] != "production"
    get "/error" do
      smtp = {
        :host     => 'smtp.gmail.com',
        :port     => '587',
        :user     => 'm4kevoid@gmail.com',
        :password => File.read("/Users/#{`whoami`.strip}/.password").gsub(/33/, '').strip,
        :auth     => :plain,           # :plain, :login, :cram_md5, no auth by default
        :domain   => "gmail.com"
      }
      mail = 'makevoid@gmail.com'
      Pony.mail(:to => mail, :from => mail, :subject => 'hi', :body => 'Hello there.', smtp: smtp)
    end
    
    # Pony.mail(:to=>"someeamil@example.com", 
    #           :from => 'yourgmail@yourdomian.com', 
    #           :subject=> "SUBJECT",
    #           :body => "BODY",
    #           :via => :smtp, :smtp => {
    #             :host       => 'smtp.gmail.com',
    #             :port       => '587',
    #             :user       => 'yourgmail@yourdomian.com',
    #             :password   => 'pazzword',
    #             :auth       => :plain,
    #             :domain     => "yourdomian.com"
    #            }
    #          )
    
    
    
    get "/migrate" do
      DataMapper.auto_migrate!
      "migrated! <br><a href='/'>back Home</a>"
    end
  end
end

require "#{APP_PATH}/controllers/creations"
require "#{APP_PATH}/controllers/users"