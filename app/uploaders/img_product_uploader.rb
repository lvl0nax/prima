# -*- encoding : utf-8 -*-

class ImgProductUploader < CarrierWave::Uploader::Base

    require 'carrierwave/processing/mini_magick'
    include CarrierWave::MiniMagick

    storage :file

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    process :convert => 'jpg'

    version :thumb do
       process :resize_to_fill => [175, 165]
    end
    version :big do
       process :resize_to_fit => [350, 270]
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end

end
