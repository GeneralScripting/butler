class CreateProjectAccesses < ActiveRecord::Migration
  def change
    create_table :project_accesses do |t|
      t.references :project, :user
      t.string :mode
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :project_accesses, :project_id
    add_index :project_accesses, :user_id
    add_index :project_accesses, :mode
  end
end