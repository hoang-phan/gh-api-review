class Comment < ActiveRecord::Base
  belongs_to :commit
end
