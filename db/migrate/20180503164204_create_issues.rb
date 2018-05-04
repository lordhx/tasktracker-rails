class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :issues do |t|
      t.integer :status
      t.references :author, foreign_key: true
      t.references :assignee, foreign_key: true

      t.timestamps
    end
  end
end
