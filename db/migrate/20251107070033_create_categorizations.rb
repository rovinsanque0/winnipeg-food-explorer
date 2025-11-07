class CreateCategorizations < ActiveRecord::Migration[7.2]
  def change
    create_table :categorizations do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
