require Rails.root.join('lib', 'helpers', 'collection_fetch')

class BranchesFetch
  include Sidekiq::Worker
  include ::CollectionFetch

  def perform(repo_id)
    repository = Repository.find_by_id(repo_id)

    if repository
      fetch_single_attribute(repository.branches, $client.branches(repository.full_name), 'name')
    end
  end
end
