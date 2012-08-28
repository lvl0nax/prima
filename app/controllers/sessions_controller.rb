# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController
  def index
    @title = "Вход"
    if(signed_in?)
      redirect_to user_path(current_user)
    end
  end

  def create_session
    user = User.find_by_email(params[:email])
    logger.debug "============================ login ================================"
    if (user && user.has_pass?(params[:password]))
      logger.debug "============================ user found ================================"
      sign_in(user)
      logger.debug "============================ sing in method has completed ================================"
      respond_to do |format|
        format.json {
          render :json => { :res => '1', :user => user }
        }
      end
      logger.debug "============================ session should be created ================================"
    else
      logger.debug "============================ user found, but something wrong ================================"
      if (user)
        logger.debug "============================ password is inorrect ================================"
        respond_to do |format|
          format.json {
            render :json => { :res => '0', :error => "Неверный пароль, проверьте раскладку клавиатуры" }
          }
        end

      else
        logger.debug "============================ user not found ================================"
        respond_to do |format|
          format.json {
            render :json => { :res => '0', :error => "Пользователь с таким e-mail не зарегистрирован" }
          }
        end

      end

    end
  end

  def destroy_session
    cookies.delete(:id)
    cookies.delete(:salt)
    respond_to do |format|
      format.json {
        render :json => { :res => '1', :answer => "Вы вышли" }
      }
    end
  end

  def template_login
    respond_to do |format|
      format.html {
        render :layout => "template_login.html.erb"
      }
    end
  end

  def template_recover
    respond_to do |format|
      format.html {
        render :layout => "template_recover.html.erb"
      }
    end
  end

end
