class Handsonxp < Sinatra::Base
  get "/login" do
    haml :login
  end
  
  post "/login" do
    user = User.first(nickname: params[:username]) || User.first(email: params[:username])
    if user && user.authorized?(params[:password])
      @cur_user = user
      session[:user_id] = user.id
      flash[:notice] = "Hai effettuato l'accesso!"
      redirect "/"
    else
      flash[:error] = "Username e/o password errati!"
      haml :"login"
    end
  end
  
  get "/logout" do
    session[:user_id] = nil
    flash[:notice] = "Logout effettuato!"
    redirect "/"
  end
end