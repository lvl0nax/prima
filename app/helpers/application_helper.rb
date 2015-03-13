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
    @pages ||= Page.all
  end

  def all_categories
    @categories ||= Category.all
  end

  def banner_pack
    @banner ||= Banner.all.shuffle
  end

end
