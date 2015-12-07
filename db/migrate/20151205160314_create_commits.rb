class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :sha
      t.string :message
      t.string :committer
      t.datetime :committed_at
      t.references :repository, index: true
      t.timestamps null: false
    end

    add_index :commits, :sha
    add_index :commits, :committed_at
  end
end
