class Commit < ActiveRecord::Base
  belongs_to :repository
  has_many :file_changes
  has_many :comments

  def github_url
    "https://github.com/#{repository.full_name}/commit/#{sha}"
  end

  def short_message
    message.split("\n").first
  end
end
