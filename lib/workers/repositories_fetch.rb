class RepositoriesFetch
  include Sidekiq::Worker

  def perform
    Repository.destroy_all

    $client.repositories(GITHUB_ENV['owner_name']).map do |repo|
      Repository.find_or_create_by(full_name: repo['full_name'])
    end
  end
end
