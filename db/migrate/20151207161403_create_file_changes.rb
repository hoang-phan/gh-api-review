class CreateFileChanges < ActiveRecord::Migration
  def change
    create_table :file_changes do |t|
      t.string :filename
      t.string :patch
      t.json :line_changes
      t.json :suggestions
      t.references :commit, index: true, foreign_key: { on_delete: :cascade }
      t.timestamps null: false
    end
  end
end
