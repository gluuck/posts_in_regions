class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :patronymic
      t.references :region, null: false, foreign_key: true
      t.integer :role, default: 0

      t.timestamps
    end
  end
end
