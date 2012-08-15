# -*- encoding : utf-8 -*-
class AddFiltersToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :filters, :string
  end

  def self.down
    remove_column :products, :filters
  end
end
