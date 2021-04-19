module AttendancesHelper
  
  # show.htmlの「出勤登録」「退勤登録」ボタンを表示する条件。
  # show.htmlのview内に直接記述してもよいが、わかりやすくここにまとめて記述するほうがよい。
  
  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    false
  end
end