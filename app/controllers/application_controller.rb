class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper  #sessionshelperコントローラーの内容を、どのコントローラーからでも利用できるようにするための設定

  # グローバル変数　頭に「＄」マークをつける。どこからでも呼び出すことが可能。
  # %wの記述は「rubyのリテラル表記」と呼ばれるもの。
  # ["日", "月", "火", 〜]と記述する配列と同じように使える。
  $days_of_the_week = %w{日 月 火 水 木 金 土}


# 以下set_userからadmin_userまで、users_controllerからapplication_controllerへ移動

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
# ここまで

  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month 
    # 月の初日を取得。「Date.current」は「当日」を取得できます。そこにrailsメソッドの「beginning_of_month」を繋ぐと「当月の初日」を取得できる。
      # showアクションの「前月へ、翌月へボタン」を押した場合、「前月、翌月のデータ」をparamsに含めて情報を送る
      # そのため、まずは「そのparamsデータがあるかどうか？」を確認し、なければ「Date.current.beginning_of_month」で当月データを取得。
      # なければ「params[:date].to_date」で、paramsで送られてきた「前月、翌月」の情報を元に、@first_dayに入れる。
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    # @first_day（つまり「当月の初日」）を取得することで、railsメソッドの「end_of_month」で「当月の終日」を取得できる。
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
end