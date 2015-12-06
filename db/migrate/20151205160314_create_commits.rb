class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :sha
      t.string :message
      t.string :committer
      t.datetime :committed_at
      t.references :repository
      t.timestamps null: false
    end
  end
end
