# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
User.create!(
  email: "demo@zauberware.com",
  password: "demo123",
  password_confirmation: "demo123",
  first_name: "John",
  last_name: "Doe"
)
