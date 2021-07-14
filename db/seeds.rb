user = User.create(
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD'],
  password_confirmation: ENV['ADMIN_PASSWORD'],
  first_name: ENV['ADMIN_FIRST_NAME'],
  last_name: ENV['ADMIN_LAST_NAME'],
  role: 'superadmin'
)

if user
  Rails.logger.info "Login with #{ENV['ADMIN_EMAIL']} and #{ENV['ADMIN_PASSWORD']}"
end

# Create a admin user
admin = User.create(
  email: Faker::Internet.email,
  password: ENV['ADMIN_PASSWORD'],
  password_confirmation: ENV['ADMIN_PASSWORD'],
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  role: 'admin'
)

User.create(
  email: Faker::Internet.email,
  password: ENV['ADMIN_PASSWORD'],
  password_confirmation: ENV['ADMIN_PASSWORD'],
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  role: 'user',
  company_id: admin.company_id
)

User.create(
  email: Faker::Internet.email,
  password: ENV['ADMIN_PASSWORD'],
  password_confirmation: ENV['ADMIN_PASSWORD'],
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  role: 'user',
  company_id: admin.company_id
)
