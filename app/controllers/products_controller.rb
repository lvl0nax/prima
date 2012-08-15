# -*- encoding : utf-8 -*-
class ProductsController < ApplicationController

  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @product }
    end
  end

  def new
    if is_admin? || is_urik_post?
        @product = Product.new
        @label_btn = "Добавить товар"
        if !params[:category_id].blank?
          arr_c = Category.find_by_id(params[:category_id]).filters
          if(!arr_c.blank?)
            arr_cs = arr_c.split("&")
            @filters = Filter.find_all_by_id(arr_cs)
          end
        else
          @filters = Filter.all
        end
    else
        redirect_to root_url
    end
  end

  def edit
    if is_admin? || (current_user  && current_user.id == Product.find(params[:id]).user_id)
        @product = Product.find(params[:id])
        @label_btn = "сохранить изменения"
        
        if !params[:category_id].blank?
          arr_c = Category.find_by_id(params[:category_id]).filters
          if(!arr_c.blank?)
            arr_cs = arr_c.split("&")
            @filters = Filter.find_all_by_id(arr_cs)
          end
        else
          @filters = Filter.all
        end
        
        @prod_filter = {}
        if(!@product.filters.blank?)
          @product.filters.split("&").each do |sp|
            @prod_filter[sp.split("-")[0]] = sp.split("-")[1]
          end
        end
    else
        redirect_to root_url
    end

  end

  def create

    params[:product][:discount] = params[:product][:discount].blank? ? 0 : params[:product][:discount]

    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, :notice => 'Product was successfully created.' }
        format.json { render :json => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.json { render :json => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @product = Product.find(params[:id])

    if(params[:product][:img_product].blank?)
      params[:product][:img_product] = @product.img_product
    end
    if(params[:product][:discount].blank?)
      params[:product][:discount] = 0
    end

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, :notice => 'Product was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    if(!is_admin?)
      return false
    end
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to categories_path }
      format.json { head :ok }
    end
  end
end
