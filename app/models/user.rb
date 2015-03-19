# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :products
  has_many :suborders
  has_many :orders

  mount_uploader :img, ImgUploader

  ROLES = {
      1 => "Администратор",
      2 => "Физическое лицо",
      3 => "Юридическое лицо (потребитель)",
      4 => "Юридическое лицо (поставщик)"
  }


end
