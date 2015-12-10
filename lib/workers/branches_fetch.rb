require Rails.root.join('lib', 'helpers', 'collection_fetch')

class BranchesFetch
  include Sidekiq::Worker
  include ::CollectionFetch

  def perform(repo_id)
    repository = Repository.find_by_id(repo_id)

    if repository
      fetch_single_attribute(Branch.where(repository: repository), 'name') do |page|
        $client.branches(repository.full_name, page: page, per_page: GITHUB_ENV['results_per_page'])
      end
    end
  end
end
