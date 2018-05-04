puts "Creating Users..."
default_password = '1q2w3e4r'

alice = User.create(role: :regular, email: 'alice@example.com', password: default_password)
bob = User.create(role: :regular, email: 'bob@example.com', password: default_password)

junior_manager = User.create(role: :manager, email: 'junior.manager@example.com', password: default_password)
senior_manager = User.create(role: :manager, email: 'senior.manager@example.com', password: default_password)

puts "Creating Issues..."
Issue.create(description: 'Is it safe to give you my credit card credentials?', author: bob)

Issue.create(description: 'Bob doesn''t talk to me', author: alice)
Issue.create(description: 'Where is my cookies?', author: alice, status: :in_progress, assignee: junior_manager)
Issue.create(description: 'Can''t login into the system', author: alice, status: :resolved, assignee: senior_manager)
