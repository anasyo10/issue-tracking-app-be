class CreateIssues < ActiveRecord::Migration[8.0]
  def change
    create_table :issues do |t|
      t.string :title
      t.text :description
      t.string :assigned_to
      t.integer :status, default: 0
      t.bigint :project_id

      t.timestamps
    end

    add_foreign_key :issues, :projects, column: :project_id, on_delete: :cascade
  end
end
