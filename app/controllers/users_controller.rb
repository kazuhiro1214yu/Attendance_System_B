class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:index, :show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]


  def index
    @users = User.paginate(page: params[:page])
  end


  def show
    # @user = User.find(params[:id])    before_actionのset_userで「@user」をまとめて定義したので不要
  end
  
  def new
    @user = User.new 
    #ユーザーオブジェクトを作成し、インスタンス変数に代入。
    #「空のuserオブジェクト」を作成して、「その空のオブジェクト」にuser新規作成画面で入力した項目を組み込んでくれる
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user #新規作成して保存成功後、ログインする。
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end  
  end 
  
  def edit
  end 
  
  def update
    # @user = User.find(params[:id])    before_actionのset_userで「@user」をまとめて定義したので不要
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end 
  end 
  
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end 
    
    # paramsハッシュからユーザーを取得します。    
    def set_user
      @user = User.find(params[:id])
    end 
    
    # ログイン済みのユーザーか確認します。
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      # @user = User.find(params[:id])    before_actionのset_userで「@user」をまとめて定義したので不要
      redirect_to(root_url) unless current_user?(@user)
    end
end