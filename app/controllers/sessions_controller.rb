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

    if (user && user.has_pass?(params[:password]))

      sign_in(user)

      respond_to do |format|
        format.json {
          render :json => { :res => '1', :user => user }
        }
      end

    else

      if (user)

        respond_to do |format|
          format.json {
            render :json => { :res => '0', :error => "Неверный пароль, проверьте раскладку клавиатуры" }
          }
        end

      else

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
