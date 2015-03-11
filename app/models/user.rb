# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :products
  has_many :suborders
  has_many :orders

  attr_accessor :skip_pass
  attr_accessor :password

  mount_uploader :img, ImgUploader

  ROLES = {
      1 => "Администратор",
      2 => "Физическое лицо",
      3 => "Юридическое лицо (потребитель)",
      4 => "Юридическое лицо (поставщик)"
  }

  def self.authenticate( id, pass )
      user = find(id)
      (user && user.enc_pass == pass.to_s) ? user : nil
  end

  def has_pass?(password)
      self.enc_pass == Digest::SHA2.hexdigest(password)
  end
end
