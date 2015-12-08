class CreateFileChanges < ActiveRecord::Migration
  def change
    create_table :file_changes do |t|
      t.string :file_name
      t.text :patch
      t.references :commit, index: true
      t.timestamps null: false
    end
  end
end
