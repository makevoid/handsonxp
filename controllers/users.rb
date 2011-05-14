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
  
  put "/users/:nick" do
    if user.update(params[:user])
      redirect "/users/#{params[user_p]}"
    else
      haml :"users/edit"
    end
  end
  
  delete "/users/:nick" do
    user.destroy
    flash[:notice] = "User deleted"
    redirect "/users"
  end
  
  get "/users/:nick/creations" do
    @creations = user.creations
  end
  
  helpers do 
    def users
      @users ||= User.all
    end
    
    def user_p
      :nickname
    end
    
    def user
      @user ||= params[user_p] ? User.first(:"#{user_p}" => params[user_p]) : User.new(params[:user])
    end
  end
  
  
end