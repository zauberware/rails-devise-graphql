class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :provider, :string, null: false, default: 'email'
    add_column :users, :uid, :string, null: false, default: ''
    add_column :users, :tokens, :text

    # if your existing User model does not have an existing **encrypted_password** column uncomment below line.
    # add_column :users, :encrypted_password, :string, null: false, default: ''

    # if your existing User model does not have an existing **allow_password_change** column uncomment below line.
    # add_column :users, :allow_password_change, :boolean, default: false

    # the following will update your models so that when you run your migration

    # updates the user table immediately with the above defaults
    User.reset_column_information

    # finds all existing users and updates them.
    # if you change the default values above you'll also have to change them here below:
    User.find_each do |user|
      user.uid = user.email
      user.provider = 'email'
      user.save!
    end

    # to speed up lookups to these columns:
    add_index :users, [:uid, :provider], unique: true
  end

  def down
    # if you added **encrypted_password** above, add here to successfully rollback
    # if you added **allow_password_change** above, add here to successfully rollback
    remove_columns :users, :provider, :uid, :tokens
  end
end
