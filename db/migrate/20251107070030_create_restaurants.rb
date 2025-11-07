class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.references :ward, null: false, foreign_key: true
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :external_id
      t.string :phone
      t.string :postal_code

      t.timestamps
    end
    add_index :restaurants, :external_id, unique: true
  end
end
