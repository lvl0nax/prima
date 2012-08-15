# -*- encoding : utf-8 -*-
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :userto_id
      t.string :name
      t.string :phone
      t.string :date
      t.text :content

      t.timestamps
    end
  end
end
