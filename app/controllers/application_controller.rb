class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper  #sessionshelperコントローラーの内容を、どのコントローラーからでも利用できるようにするための設定

# グローバル変数　頭に「＄」マークをつける。どこからでも呼び出すことが可能。
# %wの記述は「rubyのリテラル表記」と呼ばれるもの。
# ["日", "月", "火", 〜]と記述する配列と同じように使える。
  $days_of_the_week = %w{日 月 火 水 木 金 土}

end
