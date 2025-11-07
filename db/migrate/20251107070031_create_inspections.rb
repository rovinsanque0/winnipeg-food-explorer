class CreateInspections < ActiveRecord::Migration[7.2]
  def change
    create_table :inspections do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.date :inspected_on
      t.string :outcome
      t.text :violations

      t.timestamps
    end
  end
end
