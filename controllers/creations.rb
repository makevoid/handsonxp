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
    @creation = cur_user.creations.new(params[:creation])
    if @creation.save && !@file.nil?
      file = @file[:tempfile].read
      
      image = MiniMagick::Image.read(file)
      image.sample "1200x800"
      image.format "png"
      path = "#{APP_PATH}/public/creations/#{creation.id}.png"
      image.write path
      
      flash[:notice] = "Opera inserita!"
      redirect "/users/#{cur_user.nick_url}/creations"
    else
      flash[:error] = "Errore nell'inserimento dell'opera, controllare di aver inserito tutti i dati"
      haml :"creations/new"
    end
  end
  
  put "/creations/:name_url" do
    if creation.update(params[:creation])
      redirect "/creations/#{creation.name_url}"
    else
      haml :"creations/edit"
    end
  end
  
  delete "/creations/:name_url" do
    creation.destroy
    flash[:notice] = "Creation deleted!"
    redirect "/users/#{cur_user.nick_url}/creations"
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