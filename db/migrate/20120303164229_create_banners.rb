# -*- encoding : utf-8 -*-
class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :title
      t.string :url
      t.string :img_banner
      t.text :description

      t.timestamps
    end
  end
end
