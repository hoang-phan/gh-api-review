require Rails.root.join('lib', 'helpers', 'collection_fetch')

class RepositoryCommitsFetch
  include Sidekiq::Worker
  include ::CollectionFetch

  def perform(repository_id)
    if repository = Repository.find_by_id(repository_id)
      watched_branches(repository).each do |branch|
        $client.commits_since(repository.full_name, started_date, branch).each do |commit|
          repository.commits.create(commit_attributes(commit))
        end
      end
    end
  end

  private

  def all_branches(repository)
    remote_values(repository.branches, 'name') do |page|
      $client.branches(repository.full_name, page: page, per_page: GITHUB_ENV['results_per_page'])
    end
  end

  def unwatched_branches(repository)
    repository.branches.pluck(:name)
  end

  def watched_branches(repository)
    all_branches(repository) - unwatched_branches(repository)
  end

  def started_date
    @started_date ||= Date.yesterday.strftime('%Y-%m-%d')
  end

  def commit_attributes(commit_json)
    {
      sha: commit_json['sha'],
      committer: commit_json['committer']['login'],
      committed_at: commit_json['commit']['author']['date'],
      message: commit_json['message']
    }
  end
end