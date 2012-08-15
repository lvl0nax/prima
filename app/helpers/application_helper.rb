# -*- encoding : utf-8 -*-
module ApplicationHelper

  def title
    return @title ? @title + " | WaterBoom (доставка воды в ваш дом или офис)" : "WaterBoom (доставка воды в ваш дом или офис)"
  end

  def truncate(text, options = {})
    options.reverse_merge!(:length => 30)
    text.truncate(options.delete(:length), options) if text
  end

  def all_pages
    return Page.all
  end

  def all_categories
    return Category.all
  end

  def banner_pack
    return Banner.all.shuffle
  end

end
