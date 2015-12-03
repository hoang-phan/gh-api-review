class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.references :repository, index: true, foreign_key: true
      t.string :name
      t.boolean :watched, default: false

      t.timestamps null: false
    end

    add_index :branches, :name
  end
end
