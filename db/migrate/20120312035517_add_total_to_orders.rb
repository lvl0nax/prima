# -*- encoding : utf-8 -*-
class AddTotalToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :total, :string
  end

  def self.down
    remove_column :orders, :total
  end
end
