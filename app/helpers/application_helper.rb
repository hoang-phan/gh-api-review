module ApplicationHelper
  def bootstrap_class_for flash_type
    case flash_type
      when :error
        "alert-error"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end
end
