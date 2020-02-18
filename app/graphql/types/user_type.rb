module Types
  class UserType < BaseModel
    field :name, String, null: false
    field :firstName, String, null: false
    field :lastName, String, null: false
    field :email, String, null: true
    field :token, String, null: false
  end
end
