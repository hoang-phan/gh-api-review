class Comment < ActiveRecord::Base
  belongs_to :commit

  def display
    [user, body, commented_at]
  end
end
