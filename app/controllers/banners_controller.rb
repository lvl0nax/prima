# -*- encoding : utf-8 -*-
class BannersController < ApplicationController

  def index
    if (!is_admin?)
        redirect_to root_url
    else
        @banners = Banner.all

        respond_to do |format|
          format.html # index.html.erb
          format.json { render :json => @banners }
        end
    end
  end

  #def show
  #  @banner = Banner.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render :json => @banner }
  #  end
  #end

  def new
    if (!is_admin?)
        redirect_to root_url
    else
        @banner = Banner.new
        @label_btn = "Добавить баннер"
    end
  end

  def edit
    if (!is_admin?)
        redirect_to root_url
    else
        @banner = Banner.find(params[:id])
        @label_btn = "Сохранить изменения"
    end
  end

  def create
    @banner = Banner.new(permitted_params)
    respond_to do |format|
      if @banner.save
        format.html { redirect_to banners_path }
        format.json { render :json => @banner, :status => :created, :location => @banner }
      else
        format.html { render :action => "new" }
        format.json { render :json => @banner.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @banner = Banner.find(params[:id])

    if(params[:banner][:img_banner].blank?)
      params[:banner][:img_banner] = @banner.img_banner
    end

    respond_to do |format|
      if @banner.update_attributes(permitted_params)
        format.html { redirect_to banners_path }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @banner.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    if(!is_admin?)
      return false
    end

    @banner = Banner.find(params[:id])
    @banner.destroy

    respond_to do |format|
      format.html { redirect_to banners_url }
      format.json { head :ok }
    end
  end

  private
  def permitted_params
    params.require(:banner).permit(:title, :url, :img_banner, :description, :position) if current_user.role.to_i == 1
  end
end
