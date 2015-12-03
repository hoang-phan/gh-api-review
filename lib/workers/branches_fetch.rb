class BranchesFetch
  include Sidekiq::Worker

  def perform(repo_id)
    repository = Repository.find_by_id(repo_id)

    if repository
      not_delete = []

      $client.branches(repository.full_name).each do |branch|
        unless repository.branches.exists?(name: branch['name'])
          repository.branches.create(name: branch['name'])
        end
        not_delete << branch['name']
      end

      repository.branches.where.not(name: not_delete).destroy_all
    end
  end
end
