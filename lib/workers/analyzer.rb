class Analyzer
  include Sidekiq::Worker

  def perform(commit_id)
    FileChange.where(commit_id: commit_id).find_each(&:analyze)
  end
end
