# -*- encoding : utf-8 -*-
class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :name
      t.text :values

      t.timestamps
    end
  end
end
