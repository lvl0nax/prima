# -*- encoding : utf-8 -*-
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.string :brand
      t.string :value_type
      t.string :value_price
      t.integer :user_id
      t.integer :category_id
      t.string :img_product
      t.text :description

      t.timestamps
    end
  end
end
