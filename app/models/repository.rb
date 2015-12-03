class Repository < ActiveRecord::Base
  scope :watched, -> { where(watched: true) }
end
