# -*- encoding : utf-8 -*-

class ImgUploader < CarrierWave::Uploader::Base
    require 'carrierwave/processing/mini_magick'
    include CarrierWave::MiniMagick

    storage :file

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    process :convert => 'jpg'

    version :thumb do
       process :resize_to_fill => [50, 50]
    end
    version :big do
       process :resize_to_fit => [250, 250]
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end
end
