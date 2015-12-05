class Branch < ActiveRecord::Base
  include Concerns::Watchable

  default_scope -> { order(:id) }

  belongs_to :repository
end
