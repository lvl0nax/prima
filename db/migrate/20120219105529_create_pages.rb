# -*- encoding : utf-8 -*-
class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :description
      t.string :keywords
      t.string :descpage

      t.timestamps
    end
  end
end
