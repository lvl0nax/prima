# -*- encoding : utf-8 -*-
class UserMailer < ActionMailer::Base
  default :from => "info@webtech.spb.ru"

  def welcome_email(user, pass)
    @user = user
    @pass = pass
    @url  = "http://marketwater.webtech.spb.ru"
    mail(:to => user.email, :subject => "Добро пожаловать на waterboom.ru")
  end

  def recover_pass(user, pass)
    @pass = pass
    mail(:to => user.email, :subject => "Вам обновили пароль")
  end

  def change_pass(email, pass)
    @pass = pass
    mail(:to => email, :subject => "Вы поменяли пароль на нашем сайте")
  end
end
