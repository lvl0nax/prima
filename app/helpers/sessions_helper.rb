# -*- encoding : utf-8 -*-
module SessionsHelper
  def sign_in(user)

    cookies.permanent.signed[:id] = [user.id]
    cookies.permanent.signed[:salt] = [user.enc_pass]

  end

  def current_user
    logger.debug "*********** current_user method ******************"
    logger.debug "*********** current_user=#{@current_user} ******************"
    @current_user ||= user_from_remember
  end

  def signed_in?
    !current_user.nil?
  end

  def is_admin?
    !current_user.nil? && current_user.role.to_i == 1
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

  private

    def user_from_remember
      logger.debug "============================ user_from_remember method ================================"
      User.authenticate(remember_id, remember_pass)
      #logger.debug "============================ #{remember_id} - #{remember_pass} ================================"
    end

    def remember_id
      logger.debug "============================ remember_id method ================================"
      cookies.signed[:id] || [nil]
    end

    def remember_pass
      logger.debug "============================ remember_pass ================================"
      cookies.signed[:salt] || [nil]
    end

end
