class CreateFileChanges < ActiveRecord::Migration
  def change
    create_table :file_changes do |t|
      t.string :filename
      t.string :patch
      t.json :line_changes
      t.references :commit, index: true
      t.timestamps null: false
    end
  end
end
