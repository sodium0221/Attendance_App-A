module UsersHelper
  
  # 勤怠基本情報を指定のフォーマットで返します。
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0)
  end
  
  def apply_message
    if Attendance.where(superior_marking: current_user.name).present?
      return "have_messages"
    end
  end

  def format_time(time)
    if time.present?
      l(time, format: :time)
    end 
  end
  
  def options_for_select_form_enum(klass, column)
    enum_list = klass.send(column.to_s.pluralize)
    enum_list.map do | name, _value |
      [ t("enums.#{klass.to_s.downcase}.#{column}.#{name}") , name ]
    end 
  end
end
