# -*- encoding : utf-8 -*-
module SessionsHelper

  def signed_in?
    !current_user.nil?
  end

  def is_admin?
    current_user.present? && current_user.role.to_i == 1
  end

  def is_fizik?
    !current_user.nil? && current_user.role.to_i == 2
  end

  def is_urik_potr?
    !current_user.nil? && current_user.role.to_i == 3
  end

  def is_urik_post?
    !current_user.nil? && current_user.role.to_i == 4
  end
end
