# -*- encoding : utf-8 -*-
class Filter < ActiveRecord::Base
  def arr_val
    buffer = {}
    self.values.split("&").each do |sp|
      buffer[sp.split(")*")[0]] = sp.split(")*")[1]
    end
    return buffer
  end
end
