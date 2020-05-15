# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_15_205622) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bydays", force: :cascade do |t|
    t.string "name"
    t.string "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_bydays_on_name"
  end

  create_table "ctlists", force: :cascade do |t|
    t.string "listid"
    t.string "creator"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator"], name: "index_ctlists_on_creator"
    t.index ["listid"], name: "index_ctlists_on_listid"
  end

  create_table "fblinks", force: :cascade do |t|
    t.string "url"
    t.string "link"
    t.string "link_domain"
    t.string "title"
    t.string "date"
    t.string "updated"
    t.decimal "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "list"
    t.string "platform_id"
    t.string "platform_name"
    t.index ["date"], name: "index_fblinks_on_date"
    t.index ["link"], name: "index_fblinks_on_link"
    t.index ["link_domain"], name: "index_fblinks_on_link_domain"
    t.index ["list"], name: "index_fblinks_on_list"
    t.index ["platform_id"], name: "index_fblinks_on_platform_id"
    t.index ["platform_name"], name: "index_fblinks_on_platform_name"
    t.index ["score"], name: "index_fblinks_on_score"
    t.index ["updated"], name: "index_fblinks_on_updated"
    t.index ["url"], name: "index_fblinks_on_url"
  end

end
