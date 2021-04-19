class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    # @user = User.find(params[:id])    before_actionのset_userで「@user」をまとめて定義したので不要

  # 以下、application.controllerの「set_one_month」に記述したため、ここへの記述は不要
  # set_one_monthはbefore_actionで実行させる。
    # # 月の初日を取得。「Date.current」は「当日」を取得できます。そこにrailsメソッドの「beginning_of_month」を繋ぐと「当月の初日」を取得できる。
    # @first_day = Date.current.beginning_of_month
    # # @first_day（つまり「当月の初日」）を取得することで、railsメソッドの「end_of_month」で「当月の終日」を取得できる。
    # @last_day = @first_day.end_of_month
    
    @worked_sum = @attendances.where.not(started_at: nil).count
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
  
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end 
  
  # 基本勤務時間の編集画面を表示するアクション（モーダルウインドウ）
  def edit_basic_info
  end 
  
  # 基本勤務時間の編集画面（モーダルウインドウ）から入力した情報を更新するためのアクション
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end 
  
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end 
    
    # モーダルウインドウを使って「基本情報編集」を表示。そこで編集した情報を更新させる必要がある
    # ストロングパラメータを利用して、セキュリティを高める必要あり。そのための設定
    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
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
    
    # システム管理権限所有かどうか判定します。
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
    
end