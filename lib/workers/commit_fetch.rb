require Rails.root.join('lib', 'helpers', 'collection_fetch')

class CommitFetch
  include Sidekiq::Worker
  include ::CollectionFetch

  def perform(commit_id)
    if commit = Commit.find_by(id: commit_id)
      commit.files.destroy_all
      
      files = $client.commit(commit.repository.full_name, commit.sha)['files']
      
      files.each do |file|
        FileChange.create(filename: file['filename'], patch: file['patch'])
      end
    end
  end
end
