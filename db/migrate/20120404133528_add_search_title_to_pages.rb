# -*- encoding : utf-8 -*-
class AddSearchTitleToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :search_title, :string
  end

  def self.down
    remove_column :pages, :search_title
  end
end
