# -*- encoding : utf-8 -*-
class ImgBannerUploader < CarrierWave::Uploader::Base

    require 'carrierwave/processing/mini_magick'
    include CarrierWave::MiniMagick

    storage :file

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    process :convert => 'jpg'

    version :mini do
       process :resize_to_fill => [226, 116]
    end

    version :left do
       process :resize_to_fit => [275, 10000]
    end

    version :top do
       process :resize_to_fill => [970, 274]
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end

end
