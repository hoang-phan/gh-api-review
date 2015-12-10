require Rails.root.join('lib', 'helpers', 'collection_fetch')

class CommitFetch
  include Sidekiq::Worker
  include ::CollectionFetch

  def perform(sha)
    if commit = Commit.find_by(sha: sha)
      FileChange.where(commit: commit).delete_all

      files = $client.commit(commit.repository.full_name, commit.sha, per_page: GITHUB_ENV['results_per_page'])['files']

      FileChange.import(files.map do |file|
        FileChange.new(filename: file['filename'], patch: file['patch'], line_changes: PatchHelper.build_patch(file['patch']), commit_id: commit.id)
      end)
    end
  end
end
