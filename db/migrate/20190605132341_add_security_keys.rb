class AddSecurityKeys < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :current_challenge, :string
    create_table :security_keys do |t|
      t.bigint "user_id"
      t.string "external_id"
      t.string "public_key"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["user_id"], name: "index_security_keys_on_user_id"
    end
  end
end
