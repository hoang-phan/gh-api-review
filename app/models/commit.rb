class Commit < ActiveRecord::Base
  belongs_to :repository
  has_many :file_changes
  has_many :comments

  scope :from_newest, -> { order(committed_at: :desc) }

  def github_url
    "https://github.com/#{repository.full_name}/commit/#{sha}"
  end

  def short_message
    message.split("\n").first
  end

  def line_comments
    result = {}
    comments.from_oldest.each do |comment|
      result[comment.filename] ||= {}
      result[comment.filename][comment.line] ||= []
      result[comment.filename][comment.line] << comment.display
    end
    result
  end

  def num_suggestions
    file_changes.to_a.sum do |file|
      file.suggestions.to_a.count
    end
  end
end
