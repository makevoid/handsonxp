# encoding: utf-8

class Handsonxp < Sinatra::Base
  
  get "/creations" do
    haml :"creations/index"
  end
  
  get "/creations/:category/category" do
    @category = params[:category]
    haml :"creations/category"
  end
  
  get "/creations/new" do
    haml :"creations/new"
  end
  
  get "/creations/:name_url" do 
    return not_found if creation.nil?
    haml :"creations/show"
  end
  
  
  post "/creations" do
    @file = params[:file]
    
    if creation.save
      file = @file[:tempfile].read
          
      path = "#{APP_PATH}/public/creations/#{creation.id}.png"
      File.open(path, "w") { |f| f.write file }
    end
    flash[:notice] = "Creation inserted!"
    redirect "/what_i_do"
  end
  
  put "/creations/:name_url" do
    if creation.update(params[:creation])
      redirect "/creations/#{creation.name_url}"
    else
      haml :"creations/edit"
    end
  end
  
  delete "/users/:nick/creations/:name_url" do
    redirect "/creations/#{creation_p}"
  end
  
  helpers do  
    def creation_p
      :name_url
    end
    
    def creations
      @creations ||= Creation.all
    end
    
    def creation
      @creation ||= params[creation_p] ? Creation.first(:"#{creation_p}" => params[creation_p]) : Creation.new(params[:creation])
    end
  end
end