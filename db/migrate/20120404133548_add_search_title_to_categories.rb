# -*- encoding : utf-8 -*-
class AddSearchTitleToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :search_title, :string
  end

  def self.down
    remove_column :categories, :search_title
  end
end
