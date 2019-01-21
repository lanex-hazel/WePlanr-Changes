# To fix Camaleon CMS bugs
class CamaleonCms::UserDecorator < Draper::Decorator
  delegate_all

  def can_edit_file? any=''
    true
  end

  def admin?
    true
  end

  def the_avatar
    ''
  end

  def the_role
    ''
  end

  def created_at
    Date.current
  end

  def fullname
    'WePlanr'
  end
end
