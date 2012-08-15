# -*- encoding : utf-8 -*-
class AddSuborderIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :suborder_id, :integer
    add_column :orders, :status, :integer
  end

  def self.down
    remove_column :orders, :suborder_id
    remove_column :orders, :status
  end
end
