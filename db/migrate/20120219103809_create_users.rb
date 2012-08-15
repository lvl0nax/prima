# -*- encoding : utf-8 -*-
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :enc_pass
      t.string :role
      t.string :bday
      t.string :company_name
      t.string :contact_fio
      t.string :phone
      t.string :img
      t.text :about

      t.timestamps
    end
  end
end
