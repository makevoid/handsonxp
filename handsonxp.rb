require 'haml'
require 'sass'
require 'sinatra'
enable :sessions

path = File.expand_path "../", __FILE__
APP_PATH = path

class String
  def titleize
    self.gsub(/\s+/, "_").downcase
  end
end

class Handsonxp < Sinatra::Base
  require "#{APP_PATH}/config/env"
  
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

  def not_found(object=nil)
    halt 404, "404 - Page Not Found"
  end
  
  helpers do 

  end

  get "/" do
    haml :index
  end

  get "/creations/*" do |id|
    @creation = Creation.get id
    return not_found if @creation.nil?
    haml :creation
  end

  get "/yes_i_am" do
    haml :yes_i_am
  end
  
  get "/what_i_do" do # aka get /creations
    @creations = Creation.all
    haml :what_i_do
  end
  
  get "/creations/new" do
    haml :creations_new
  end
  
  get "/category/*" do |category|
    @category = category
  end
  
  post "/creations" do
    # raise params.inspect
    @creation = Creation.new params[:creation]
    @file = params[:file]
    
    if @creation.save
      file = @file[:tempfile].read
          
File.open("#{APP_PATH}/public/creations/#{@creation.id}.png", "w") { |f| f.write file }
    end
    flash[:notice] = "Creation inserted!"
    redirect "/what_i_do"
  end

  get '/css/main.css' do
    sass :main
  end
  
  if ENV['RACK_ENV'] != "production"
    get "/migrate" do
      DataMapper.auto_migrate!
      "migrated! <br><a href='/'>back Home</a>"
    end
  end
end