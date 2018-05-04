class AddDescriptionIntoIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :description, :text
  end
end
