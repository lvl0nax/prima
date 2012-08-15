# -*- encoding : utf-8 -*-
class AddMainFlagToFilters < ActiveRecord::Migration
  def self.up
    add_column :filters, :main_flag, :boolean
    Filter.all.each do |f|
      f.update_attributes!(:main_flag => 'false')
    end
  end

  def self.down
    remove_column :filters, :main_flag
  end
end
