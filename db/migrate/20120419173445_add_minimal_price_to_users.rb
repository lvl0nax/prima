# -*- encoding : utf-8 -*-
class AddMinimalPriceToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :minimal_price, :string
  end

  def self.down
    remove_column :users, :minimal_price
  end
end
