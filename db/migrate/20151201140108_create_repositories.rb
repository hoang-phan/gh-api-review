class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :full_name
      t.boolean :watched, default: false
      t.timestamps null: false
    end

    add_index :repositories, :full_name
    add_index :repositories, :watched
  end
end
