class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new 
    #ユーザーオブジェクトを作成し、インスタンス変数に代入。
    #「空のuserオブジェクト」を作成して、「その空のオブジェクト」にuser新規作成画面で入力した項目を組み込んでくれる
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end  
  end 
  
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end 
end