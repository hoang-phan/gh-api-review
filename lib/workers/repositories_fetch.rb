require Rails.root.join('lib', 'helpers', 'collection_fetch')

class RepositoriesFetch
  include Sidekiq::Worker
  include ::CollectionFetch

  def perform
    fetch_single_attribute(Repository, $client.organization_repositories(GITHUB_ENV['owner_name']), 'full_name')
  end
end
