require Rails.root.join('lib', 'helpers', 'collection_fetch')

class CommentsFetch
  include Sidekiq::Worker

  def perform(sha)
    if commit = Commit.find_by(sha: sha)
      Comment.where(commit: commit).delete_all

      comments = $client.commit_comments(commit.repository.full_name, commit.sha, per_page: GITHUB_ENV['results_per_page'])

      Comment.import(comments.map do |comment|
        Comment.new(
          external_id: comment['id'],
          filename: comment['path'],
          body: comment['body'],
          user: comment['user']['login'],
          line: comment['line'],
          commented_at: comment['updated_at'],
          commit_id: commit.id
        )
      end)
    end
  end
end