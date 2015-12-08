require Rails.root.join('lib', 'helpers', 'collection_fetch')

class CommitFetch
  include Sidekiq::Worker
  include ::CollectionFetch

  def perform(sha)
    if commit = Commit.find_by(sha: sha)
      commit.file_changes.destroy_all

      files = $client.commit(commit.repository.full_name, commit.sha, per_page: GITHUB_ENV['results_per_page'])['files']

      files.each do |file|
        commit.file_changes.create(filename: file['filename'], patch: file['patch'])
      end
    end
  end
end
