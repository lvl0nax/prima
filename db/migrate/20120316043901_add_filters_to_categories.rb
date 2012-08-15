# -*- encoding : utf-8 -*-
class AddFiltersToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :filters, :string
  end

  def self.down
    remove_column :categories, :filters
  end
end
