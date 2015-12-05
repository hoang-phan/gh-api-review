class Repository < ActiveRecord::Base
  STRING_WATCHED = 'watched'
  STRING_UNWATCHED = 'unwatched'

  default_scope -> { order(:id) }

  scope :watched, -> { where(watched: true) }

  has_many :branches, dependent: :destroy

  def watched_string
    watched ? STRING_WATCHED : STRING_UNWATCHED
  end
end
