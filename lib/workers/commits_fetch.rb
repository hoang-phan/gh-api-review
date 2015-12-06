class CommitsFetch
  include Sidekiq::Worker

  def perform
    Repository.watched.pluck(:id).each do |repository_id|
      RepositoryCommitsFetch.perform_async(repository_id)
    end
  end
end