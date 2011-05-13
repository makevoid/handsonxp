class Handsonxp < Sinatra::Base
  
  get "/users" do
    haml :"users/index"
  end
  
  get "/users/:name" do
    haml :"users/show"
  end
  
  get "/users/new" do
    haml :"users/new"
  end
  
  post "/users" do
    if user.save
      redirect "/users"
    else
      haml :"users/new"
    end
  end
  
  
  helpers do 
    def users
      @users ||= User.all
    end
    
    def user
      @user ||= params[:id] ? User.get(params[:id]) : User.new(params[:work])
    end
  end
  
  
end