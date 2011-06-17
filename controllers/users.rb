class Handsonxp < Sinatra::Base
  
  get "/users" do
    haml :"users/index"
  end
  
  get "/users/new" do
    haml :"users/new"
  end
  
  get "/users/:nick_url/edit" do
    haml :"users/edit"
  end
  
  get "/users/:nick_url" do
    return not_found if user.nil?
    @creations = user.creations
    haml :"users/show"
  end
  
  
  post "/users" do
    if user.save
      @cur_user = user
      session[:user_id] = user.id
      flash[:notice] = "Benvenuto in handsonxp! Ora sei un'utente registrato!"
      redirect "/users/#{user.nick_url}"
    else
      flash[:error] = "Errore nel processo di registrazione"
      haml :"users/new"
    end
  end
  
  put "/users/:nick_url" do
    if user.update(params[:user])
      redirect "/users/#{params[user_p]}"
    else
      haml :"users/edit"
    end
  end
  
  delete "/users/:nick_url" do
    user.destroy
    flash[:notice] = "Utente cancellato"
    redirect "/users"
  end
  
  get "/users/:nick_url/creations" do
    @creations = user.creations
    haml :"users/creations"
  end
  
  helpers do 
    def users
      @users ||= User.all
    end
    
    def user_p
      :nick_url
    end
    
    def user
      @user ||= params[user_p] ? User.first(:"#{user_p}" => params[user_p]) : User.new(params[:user])
    end
  end
  
  
end