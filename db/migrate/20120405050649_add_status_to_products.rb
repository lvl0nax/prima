# -*- encoding : utf-8 -*-
class AddStatusToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :status, :integer
    Product.all.each do |p|
      p.update_attributes!(:status => 0, :img_product => p.img_product)
    end
  end

  def self.down
    remove_column :products, :status
  end
end
