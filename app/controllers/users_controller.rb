# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  def index
    redirect_to "/users/list"
  end

  def show
    @user = User.find(params[:id])
    @products = products.where(user_id == params[:id])
  end

  def new
    @user = User.new
    #@users = User.find_by_role(1)
    @label_btn = "Зарегистрироваться"
  end

  def edit
    if (!current_user)
      redirect_to new_user_path
    elsif (current_user && current_user.id.to_s != params[:id] && !is_admin?)
      redirect_to root_url
    else
      @user = User.find(params[:id])
      @title = "Редактирование пользвателя " + @user.name
      @users = User.find_by_role(1)
      @label_btn = "Сохранить изменения"
    end
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      @user.skip_pass = true
      if @user.save
        sign_in(@user)
        UserMailer.welcome_email(@user, params[:user][:password]).deliver
        format.html { redirect_to "/profile", :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])

    if(params[:user][:img].blank?)
      params[:user][:img] = @user.img
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        sign_in(@user)
        format.html { redirect_to "/profile", :notice => 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    if(!is_admin? && (current_user && current_user.id != params[:id]))
      return false
    end

    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  def profile
    if(!params[:id].blank?)

        @user = User.find_by_id(params[:id])

        if(@user.blank?)
            redirect_to root_url
        else
            render :template => "/users/show.html.erb"
        end

    elsif(params[:id].blank? && current_user)

        @user = User.find_by_id(current_user.id)
        render :template => "/users/show.html.erb"

    else
        redirect_to root_url
    end
  end

    def list
        if is_admin?
            @users = User.find(:all)
            @usersObj = {}
            @users.each do |u|
                if (@usersObj[u.role.to_s].nil?)
                    @usersObj[u.role.to_s] = []
                end
                @usersObj[u.role.to_s].push(u)
            end
        else
            redirect_to root_url
        end
    end

  def checkemailvalid
    @user = User.find_by_email(params[:email])

    respond_to do |format|
      if !@user.blank? && @user != current_user
        format.json { render :json => {:status => 1}}
      else
        format.json { render :json => {:status => 0}}
      end
    end
  end

  def change_pass
    if(!current_user)
      redirect_to root_url
    end
  end

  #ajax смена пароля

  def change_pass_ajax
    respond_to do |format|
      if current_user.has_pass?(params[:old_pass])
        params[:user] = {}
        params[:user][:img] = current_user.img
        params[:user][:password] = params[:pass]
        current_user.skip_pass = true
        if current_user.update_attributes(params[:user])
          UserMailer.change_pass(current_user.email, params[:pass]).deliver
          sign_in(@user)
          format.json { render :json => {:status => 1}}
        end
      else
        format.json { render :json => {:status => 0}}
      end
    end
  end

  def recover_pass
    user = User.find_by_email(params[:email])
    respond_to do |format|
      if (user.blank?)
        format.json { render :json => {:status => 0}}
      else
        pass = random_word
        user.skip_pass = true
        if user.update_attributes({:password => pass, :img => user.img})
          UserMailer.recover_pass(user, pass).deliver
          format.json { render :json => {:status => 1}}
        end
      end
    end
  end

  def random_word
    letters = { ?v => 'aeiou', ?c => 'bcdfghjklmnprstvwyz' }
    word = ''
    'cvcvcvc'.each_byte do |x|
      source = letters[x]
      word << source[rand(source.length)].chr
    end
    return word
  end

end
