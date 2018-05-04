class AddDefaultStatusForIssues < ActiveRecord::Migration[5.1]
  def change
    change_column :issues, :status, :integer, default: 0, null: false
    change_column :issues, :author_id, :integer, default: 0, null: false
  end
end
