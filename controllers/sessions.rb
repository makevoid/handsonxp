class Handsonxp < Sinatra::Base
  get "/login" do
    haml :login
  end
  
  post "/login" do
    user = User.first(nickname: params[:username]) || User.first(email: params[:username])
    if user && user.authorized?(params[:password])
      @cur_user = user
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully!"
      redirect "/"
    else
      flash[:error] = "Can't login with this username and password!"
      haml :"login"
    end
  end
  
  get "/logout" do
    session[:user_id] = nil
    flash[:notice] = "Logged out successfully!"
    redirect "/"
  end
end