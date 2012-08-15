# -*- encoding : utf-8 -*-
class Order < ActiveRecord::Base
    belongs_to :user

    STATUS = %w(в\ ожидании отклонён принят готов)
end
