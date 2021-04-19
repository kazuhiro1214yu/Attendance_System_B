class Attendance < ApplicationRecord
  # 親である「Userモデル」と、1対1の関係を示す記述。Userモデルと繋がることを認識させる記述。
  belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  
  # 上のvalidate（finished_at_is〜）メソッドの実行内容。「出勤時間を入れないとだめ」とエラーを表示してくれる。
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
end