require 'haml'
require 'sass'
require 'sinatra/base'
require "sinatra/reloader" 

path = File.expand_path "../", __FILE__
APP_PATH = path

require 'pony'
require "#{path}/lib/pony_gmail"


class String
  def titleize
    self.gsub(/\s+/, "_").downcase
  end
  
  def urlize
    self.strip.gsub(/\s+/, "_").downcase
  end
  
  def namize
    stopwords = ["and", "e"]
    self.split("_").map{|w| stopwords.include?(w) ? w : w.capitalize }.join(" ")
  end
end

class Handsonxp < Sinatra::Base
  require "#{APP_PATH}/config/env"
  
  
  configure :development do # this way you can use thin, shotgun is so slow...
    register Sinatra::Reloader
    also_reload ["controllers/*.rb", "models/*.rb"]
    set :public, "public"
    set :static, true
  end
  
  set :haml, { :format => :html5 }
  require 'rack-flash'
  enable :sessions
  use Rack::Flash, sweep: true
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
  
  CATEGORIES = ["Arts and Crafts", "Multimedia", "Pictures and Photos", "Computer Land", "Green Economy", "Blue Economy", "Other"]
  
  require 'voidtools/dm/form_helpers'
  helpers Voidtools::FormHelpers
  
  helpers do
    def user
      @user ||= User.get(1) 
    end
    
    def home?
      request.path == "/"
    end
    
    def partial_collection(model, collection)
      collection.map do |item|
        name = model.to_s.downcase
        haml :"#{name.pluralize}/_#{name}", locals: { :"#{name}" => item }
      end.join("")
    end
    
    def partial(object)
      case object.class.to_s
      when /DataMapper.*::Collection/
        model = object.query.model
        partial_collection model, object
      when /Symbol|String/
        haml object
      end
    end
    
    # auth
    
    def logged_in?
      cur_user
    end
    
    def cur_user
      return false unless session[:user_id]
      @cur_user ||= User.get(session[:user_id]) 
    end
    
    alias :current_user :cur_user
  end
  
  get "/" do
    haml :index
  end
  
  get "/contacts" do
    haml :contacts
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
require "#{APP_PATH}/controllers/sessions"
require "#{APP_PATH}/controllers/users"