class RepositoriesFetch
  include Sidekiq::Worker

  def perform
    Repository.destroy_all

    $client.repositories.each do |repo|
      Repository.create(
        external_id: repo['id'],
        full_name: repo['full_name'],
        html_url: repo['html_url'],
        avatar_url: repo['owner']['avatar_url'],
        owner: repo['owner']['login']
      )
    end
  end
end