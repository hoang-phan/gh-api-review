# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151203064915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.integer  "repository_id"
    t.string   "name"
    t.boolean  "watched",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "branches", ["name"], name: "index_branches_on_name", using: :btree
  add_index "branches", ["repository_id"], name: "index_branches_on_repository_id", using: :btree

  create_table "repositories", force: :cascade do |t|
    t.string   "full_name"
    t.boolean  "watched",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "repositories", ["full_name"], name: "index_repositories_on_full_name", using: :btree
  add_index "repositories", ["watched"], name: "index_repositories_on_watched", using: :btree

  add_foreign_key "branches", "repositories"
end
