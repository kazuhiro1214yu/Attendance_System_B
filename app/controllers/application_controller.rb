class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper  #sessionshelperコントローラーの内容を、どのコントローラーからでも利用できるようにするための設定
end
