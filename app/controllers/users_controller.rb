# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  def index
    redirect_to "/users/list"
  end

  def show
    @user = User.find(params[:id])
    @products = Product.where(user_id: params[:id])
  end

  def edit
    if current_user.blank?
      redirect_to new_user_path
    elsif current_user && current_user.id.to_s != params[:id] && !is_admin?
      redirect_to root_url
    else
      @user = User.find(params[:id])
      @title = "Редактирование пользвателя " + @user.try(:name).to_s
      @users = User.where(role: 1)
      @label_btn = "Сохранить изменения"
    end
  end

  def create
    @user = User.new(permitted_params)
    respond_to do |format|
      if @user.save
        sign_in(@user)
        # UserMailer.welcome_email(@user, params[:user][:password]).deliver
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

    permitted_params[:img] = @user.img if permitted_params[:img].blank?

    respond_to do |format|
      if @user.update_attributes(permitted_params)
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
    if params[:id].present?

        @user = User.find(params[:id])

        if(@user.blank?)
            redirect_to root_url
        else
            render :template => "/users/show.html.erb"
        end

    elsif params[:id].blank? && current_user

        @user = current_user
        render template: "/users/show.html.erb"

    else
        redirect_to root_url
    end
  end

    def list
        if is_admin?
            @users = User.all
            @users_obj = {}
            @users.each do |u|
                if (@users_obj[u.role.to_s].nil?)
                  @users_obj[u.role.to_s] = []
                end
                @users_obj[u.role.to_s].push(u)
            end
        else
            redirect_to root_url
        end
    end

  def checkemailvalid
    @user = User.find_by(email: params[:email])

    respond_to do |format|
      if !@user.blank? && @user != current_user
        format.json { render :json => {:status => 1}}
      else
        format.json { render :json => {:status => 0}}
      end
    end
  end

  def signout
    sign_out current_user
    render json: {res: 1}
  end

  private
  def permitted_params
    params.require(:user).permit(:role, :name, :bday, :company_name, :img, :contact_fio, :minimal_price, :phone, :about, :password)
  end
end
