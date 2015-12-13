class Comment < ActiveRecord::Base
  belongs_to :commit

  def to_hash
    {
      line => [user, body, commented_at]
    }
  end
end
