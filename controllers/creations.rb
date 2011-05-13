class Handsonxp < Sinatra::Base
  
  get "/creations/:name" do 
    return not_found if creation.nil?
    haml :"creations/show"
  end
  
  get "/creations/new" do
    haml :"creations/new"
  end
  
  post "/creations" do
    @file = params[:file]
    
    if creation.save
      file = @file[:tempfile].read
          
File.open("#{APP_PATH}/public/creations/#{creation.id}.png", "w") { |f| f.write file }
    end
    flash[:notice] = "Creation inserted!"
    redirect "/what_i_do"
  end
  
  
  
  helpers do  
    def creations
      @creations ||= Creation.all
    end
    
    def creation
      @creation ||= params[:id] ? Creation.get(params[:id]) : Creation.new(params[:creation])
    end
  end
end