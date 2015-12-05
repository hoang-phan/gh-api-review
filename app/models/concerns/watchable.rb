module Concerns::Watchable
  extend ActiveSupport::Concern

  STRING_WATCHED = 'watched'
  STRING_UNWATCHED = 'unwatched'

  included do
    scope :watched, -> { where(watched: true) }

    def watched_string
      watched ? STRING_WATCHED : STRING_UNWATCHED
    end
  end
end