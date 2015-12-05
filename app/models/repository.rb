class Repository < ActiveRecord::Base
  scope :watched, -> { where(watched: true) }

  has_many :branches, dependent: :destroy

  def watched_string
    watched ? 'watched' : 'unwatched'
  end
end
