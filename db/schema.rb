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

ActiveRecord::Schema.define(version: 20151212073215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.integer  "repository_id"
    t.string   "name"
    t.boolean  "watched",       default: true
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "branches", ["name"], name: "index_branches_on_name", using: :btree
  add_index "branches", ["repository_id"], name: "index_branches_on_repository_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "external_id"
    t.string   "user"
    t.string   "body"
    t.integer  "commit_id"
    t.integer  "line"
    t.string   "filename"
    t.datetime "commented_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "comments", ["commented_at"], name: "index_comments_on_commented_at", using: :btree
  add_index "comments", ["commit_id"], name: "index_comments_on_commit_id", using: :btree
  add_index "comments", ["filename"], name: "index_comments_on_filename", using: :btree
  add_index "comments", ["line"], name: "index_comments_on_line", using: :btree

  create_table "commits", force: :cascade do |t|
    t.string   "sha"
    t.string   "message"
    t.string   "committer"
    t.datetime "committed_at"
    t.integer  "repository_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "commits", ["committed_at"], name: "index_commits_on_committed_at", using: :btree
  add_index "commits", ["repository_id"], name: "index_commits_on_repository_id", using: :btree
  add_index "commits", ["sha"], name: "index_commits_on_sha", using: :btree

  create_table "file_changes", force: :cascade do |t|
    t.string   "filename"
    t.string   "patch"
    t.json     "line_changes"
    t.integer  "commit_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "file_changes", ["commit_id"], name: "index_file_changes_on_commit_id", using: :btree

  create_table "repositories", force: :cascade do |t|
    t.string   "full_name"
    t.boolean  "watched",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "repositories", ["full_name"], name: "index_repositories_on_full_name", using: :btree
  add_index "repositories", ["watched"], name: "index_repositories_on_watched", using: :btree

  add_foreign_key "branches", "repositories", on_delete: :cascade
  add_foreign_key "comments", "commits", on_delete: :cascade
  add_foreign_key "commits", "repositories", on_delete: :cascade
  add_foreign_key "file_changes", "commits", on_delete: :cascade
end
