class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(login: session_params[:login])
    if (user && user.authenticate(session_params[:password]))
      sign_in user
      redirect_back_or user
    else
      flash[:error] = 'Fallo de autenticación: Los datos son incorrectos'
      render action: 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  private
  def session_params
    params.require(:session).permit(:password, :login)
  end
end
