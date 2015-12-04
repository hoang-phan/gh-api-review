class RepositoriesFetch
  include Sidekiq::Worker

  def perform
    not_delete = []

    $client.organization_repositories(GITHUB_ENV['owner_name']).each do |repo|
      unless Repository.exists?(full_name: repo['full_name'])
        Repository.create(full_name: repo['full_name'])
      end
      not_delete << repo['full_name']
    end

    Repository.where.not(full_name: not_delete).destroy_all
  end
end
