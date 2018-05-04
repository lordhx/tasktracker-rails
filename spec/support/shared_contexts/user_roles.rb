module UserRoles
  User.roles.each do |key,  _|
    role = key.to_sym
    context_name = "user is #{role}"

    shared_context context_name do
      let(:user) { create(:user, role: role) }

      before { sign_in user }
    end

    RSpec.configure do |rspec|
      rspec.include_context context_name, user: role
    end
  end
end
