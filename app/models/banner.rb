# -*- encoding : utf-8 -*-
class Banner < ActiveRecord::Base
    mount_uploader :img_banner, ImgBannerUploader
    POSITION = %w(Без\ разницы Сверху Слева)
end
