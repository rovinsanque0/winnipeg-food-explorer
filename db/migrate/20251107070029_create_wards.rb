class CreateWards < ActiveRecord::Migration[7.2]
  def change
    create_table :wards do |t|
      t.string :name
      t.string :external_id

      t.timestamps
    end
    add_index :wards, :external_id, unique: true
  end
end
