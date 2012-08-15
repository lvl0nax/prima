# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
    has_many :products
    has_many :suborders
    has_many :orders

    attr_accessor :skip_pass
    attr_accessor :password

    before_save :encrypt_password

    mount_uploader :img, ImgUploader

    ROLES = {
        1 => "Администратор",
        2 => "Физическое лицо",
        3 => "Юридическое лицо (потребитель)",
        4 => "Юридическое лицо (поставщик)"
    }

    def self.authenticate( id, pass )
        user = find_by_id(id.to_s)
        (user && user.enc_pass == pass.to_s) ? user : nil
    end

    def has_pass?(password)
        self.enc_pass == Digest::SHA2.hexdigest(password)
    end

    def encrypt_password
      unless !skip_pass.present?
        self.enc_pass = encrypt(password)
      end
    end

    def encrypt(string)
      Digest::SHA2.hexdigest(string)
    end

end
