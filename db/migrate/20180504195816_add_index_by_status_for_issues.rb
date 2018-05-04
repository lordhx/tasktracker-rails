class AddIndexByStatusForIssues < ActiveRecord::Migration[5.1]
  def change
    add_index :issues, :status
  end
end
