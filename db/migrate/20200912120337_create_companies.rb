class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies, id: :uuid do |t|
      t.string :name
      t.integer :users_count
      t.timestamps
    end
  end
end
