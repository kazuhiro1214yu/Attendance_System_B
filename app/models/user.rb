class User < ApplicationRecord
  
  # 「remember_token」という仮想の属性を作成します。
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  
  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 以下、重要な説明
  # attr_accessorの　remember-token　に上で作成したランダムなトークン「User.new_token」を入れる
  # update_attributeメソッドで、Usersテーブルカラムである「remember_digest(ハッシュ化されたトークンを保存されるカラム)」に値を入れる
  #   そのカラムに入れる値は、上のUser.digestメソッドを使い、引数である（string）に「remember_token」を入れたものを使う
  #   つまり、「remember_token」とは「User.new_tokenで作成したランダムなトークン」である
  #   それを、上のUser.digestメソッドを使ってダイジェスト用に変換させ、それをUser.digestカラムに入れて保存させる

  # 補足 update_attributesではなく「attribute(sがない)」である理由は、バリデーションを素通りさせるため。
  #      この段階ではユーザーのパスワードなどにアクセスできないため、素通りさせる必要がある
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end 
  
end