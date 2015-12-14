class Comment < ActiveRecord::Base
  belongs_to :commit

  scope :from_oldest, -> { order(:commented_at) }

  def display
    [user, body, commented_at]
  end
end
