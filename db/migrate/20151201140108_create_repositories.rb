class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.integer :external_id
      t.string :full_name
      t.string :html_url
      t.string :avatar_url
      t.string :owner
      t.timestamps null: false
    end
  end
end
