# -*- encoding : utf-8 -*-

class Product < ActiveRecord::Base

  belongs_to :category
  belongs_to :user

  mount_uploader :img_product, ImgProductUploader

  def arr_val
      buffer = {}
      if(!self.filters.blank?)
        self.filters.split("&").each do |sp|
          buffer[sp.split("-")[0]] = sp.split("-")[1]
        end
      end
    return buffer
  end

  def arr_discount
      buffer = {}

      if(!self.discount.blank?)
        self.discount.split("&").each do |sp|
          buffer[sp.split(")*")[0]] = sp.split(")*")[1]
        end
      end

      return buffer
  end

  STATUS = %w(есть\ на\ складе отсутствует под\ заказ)

end
