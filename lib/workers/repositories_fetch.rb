class RepositoriesFetch
  include Sidekiq::Worker

  def perform
    Repository.destroy_all

    $client.repositories(GITHUB_ENV['owner_name']).each do |repo|
      repository = Repository.find_or_create_by(full_name: repo['full_name'])
      $client.branches(repo['full_name']).each do |branch|
        repository.branches.find_or_create_by(name: branch['name'])
      end
    end
  end
end
