class CreateRegions < ActiveRecord::Migration[6.1]
  def change
    create_table :regions do |t|
      t.integer :r_num
      t.string :title

      t.timestamps
    end
  end
end
