# -*- encoding : utf-8 -*-
class AddEmailAddressToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :email, :string
    add_column :orders, :address, :string
  end

  def self.down
    remove_column :orders, :email
    remove_column :orders, :address
  end
end
