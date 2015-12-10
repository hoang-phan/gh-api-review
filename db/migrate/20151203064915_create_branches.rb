class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.references :repository, index: true, foreign_key: { on_delete: :cascade }
      t.string :name
      t.boolean :watched, default: true

      t.timestamps null: false
    end

    add_index :branches, :name
  end
end
