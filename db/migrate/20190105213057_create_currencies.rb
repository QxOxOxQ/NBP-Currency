class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.string :name, null: false, limit: 3
      t.decimal :rate, null: false
      t.references :day, foreign_key: true, dependent: :destroy

      t.timestamps
      end
      add_index :currencies, [:day_id, :name], unique: true
  end
end
