class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :external_id
      t.string :user
      t.string :body
      t.references :commit, index: true, foreign_key: { on_delete: :cascade }
      t.integer :line
      t.string :filename
      t.datetime :commented_at

      t.timestamps null: false
    end

    add_index :comments, :filename
    add_index :comments, :line
    add_index :comments, :commented_at
  end
end
