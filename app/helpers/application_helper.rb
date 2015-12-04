module ApplicationHelper
  TYPE_ERROR = 'error'
  TYPE_NOTICE = 'notice'

  def bootstrap_class_for flash_type
    case flash_type
      when TYPE_ERROR
        'alert-error'
      when TYPE_NOTICE
        'alert-info'
      else
        flash_type.to_s
    end
  end
end
