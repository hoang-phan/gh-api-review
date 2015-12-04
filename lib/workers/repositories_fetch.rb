require Rails.root.join('lib', 'helpers', 'collection_fetch')

class RepositoriesFetch
  include Sidekiq::Worker
  include ::CollectionFetch

  def perform
    fetch_single_attribute(Repository, 'full_name') do |page_num|
      $client.org_repos(GITHUB_ENV['owner_name'], page: page_num, per_page: GITHUB_ENV['results_per_page'])
    end
  end
end
