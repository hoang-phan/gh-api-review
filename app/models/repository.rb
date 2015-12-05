class Repository < ActiveRecord::Base
  include Concerns::Watchable 

  default_scope -> { order(:id) }

  has_many :branches, dependent: :destroy
end
