class Issue < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :assignee, class_name: 'User', optional: true

  enum status: [:pending, :in_progress, :resolved]

  PER_PAGE = 25
end
