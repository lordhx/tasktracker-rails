class Issue < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :assignee, class_name: 'User'

  enum status: [:pending, :in_progress, :resolved]
end
