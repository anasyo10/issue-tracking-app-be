class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.text :text
      t.bigint :issue_id

      t.timestamps
    end

    add_foreign_key :comments, :issues, column: :issue_id, on_delete: :cascade
  end
end
