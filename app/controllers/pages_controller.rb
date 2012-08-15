# -*- encoding : utf-8 -*-
class PagesController < ApplicationController

  def index
    @page = Page.first

    if (@page.nil?)
    else
      render :action => "show"
    end

  end

  def show

    @page = @page || Page.find(params[:id])

    @title = !@page.search_title.blank? ? @page.search_title : @page.title

  end

  def new
      if is_admin?
        @page = Page.new
        @title = "Создание страницы"
        @label_btn = "Создать страницу"
      else
          redirect_to root_url
      end
  end

  def edit
    if is_admin?
        @page = Page.find(params[:id])
        @title = "Редактирование страницы " + @page.title
        @label_btn = "Сохранить изменения"
    else
        redirect_to root_url
    end
  end

  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, :notice => 'Page was successfully created.' }
        format.json { render :json => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.json { render :json => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to @page, :notice => 'Page was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    if(!is_admin?)
      return false
    end

    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :ok }
    end
  end
end
