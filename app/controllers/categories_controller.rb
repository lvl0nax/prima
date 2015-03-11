# -*- encoding : utf-8 -*-
class CategoriesController < ApplicationController
  def index
    @title = "Поиск товаров"
    @categories = Category.all
    @filter_obj = {}
    Filter.all.each do |f|
      @filter_obj[f.id] = {}
      f.values.split("&").each do |value|
        @filter_obj[f.id][value.split(")*")[0]] = value.split(")*")[1]
      end
    end
  end

  def show
    @category = Category.find(params[:id])
    @title = !@category.search_title.blank? ? @category.search_title : @category.name
    @filter_obj = {}
    Filter.all.each do |f|
      @filter_obj[f.id] = {}
      f.values.split("&").each do |value|
        @filter_obj[f.id][value.split(")*")[0]] = value.split(")*")[1]
      end
    end
    if @category.filters.present?
      @cat_filters = Filter.where(id: @category.filters.split("&"))
    end

  end

  def new
    unless is_admin?
      redirect_to root_url
    else
      @title = "Создание категории"
      @label_btn = "Добавить категорию"
      @category = Category.new
      @filters = Filter.all

      @cat_filters = []
      if @category.filters.present?
        @cat_filters = @category.filters.split("&")
      end

    end
  end

  def edit
    if !is_admin?
      redirect_to root_url
    else
      @category = Category.find(params[:id])
      @title = "Редактирование категории " + @category.name
      @filters = Filter.all

      @cat_filters = []
      if !@category.filters.blank?
        @cat_filters = @category.filters.split("&")
      end

      @label_btn = "Сохранить изменения"
    end
  end

  def create
    @category = Category.new(permitted_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, :notice => 'Category was successfully created.' }
        format.json { render :json => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.json { render :json => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @category = Category.find(params[:id])
    respond_to do |format|
      if @category.update_attributes(permitted_params)
        format.html { redirect_to @category, :notice => 'Category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :ok }
    end
  end

  private
  def permitted_params
    params.require(:category).permit(:name, :search_title, :desccat, :description, :filters, :keywords) if current_user.role.to_i == 1
  end
end
