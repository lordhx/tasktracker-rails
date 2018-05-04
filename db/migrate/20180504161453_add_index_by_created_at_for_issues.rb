class AddIndexByCreatedAtForIssues < ActiveRecord::Migration[5.1]
  def change
    add_index :issues, :created_at
  end
end
