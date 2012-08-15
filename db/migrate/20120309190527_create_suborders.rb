# -*- encoding : utf-8 -*-
class CreateSuborders < ActiveRecord::Migration
  def change
    create_table :suborders do |t|
      t.integer :user_id
      t.string :uriks
      t.string :status

      t.timestamps
    end
  end
end
