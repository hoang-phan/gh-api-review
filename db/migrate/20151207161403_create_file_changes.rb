class CreateFileChanges < ActiveRecord::Migration
  def change
    create_table :file_changes do |t|
      t.string :filename
      t.text :patch
      t.references :commit, index: true
      t.timestamps null: false
    end
  end
end
