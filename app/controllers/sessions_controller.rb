class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) #userがtrueで、かつそのuserのパスワードが正しい場合、
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) #ログイン画面で「ログイン情報保持のチェックボックス」をチェックしたか否か
      redirect_to user
    else
      flash.now[:danger] = "認証に失敗しました。"
      render :new
    end
  end 
  
  def destroy
    log_out if logged_in?
    flash[:success] = "ログアウトしました。"
    redirect_to root_url
  end 
  
end
