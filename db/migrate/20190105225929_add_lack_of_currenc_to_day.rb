class AddLackOfCurrencToDay < ActiveRecord::Migration[5.2]
  def change
    add_column :days, :lack_of_currency, :boolean, default: false
  end
end
