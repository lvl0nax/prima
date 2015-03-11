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
          arr_c = Category.find(params[:category_id]).filters
          if arr_c.present?
            arr_cs = arr_c.split("&")
            @filters = Filter.where(id: arr_cs)
          end
        else
          @filters = Filter.all
        end
    else
        redirect_to root_url
    end
  end

  def edit
    @product = Product.find(params[:id])
    if is_admin? || (current_user  && current_user.id == @product.user_id)

        @label_btn = "сохранить изменения"
        
        if  params[:category_id].present?
          arr_c = Category.find(params[:category_id]).filters
          if arr_c.present?
            arr_cs = arr_c.split("&")
            @filters = Filter.where(id: arr_cs)
          end
        else
          @filters = Filter.all
        end
        
        @prod_filter = {}
        if @product.filters.present?
          @product.filters.split("&").each do |sp|
            @prod_filter[sp.split("-")[0]] = sp.split("-")[1]
          end
        end
    else
        redirect_to root_url
    end

  end

  def create

    params[:product][:discount] =0 if params[:product][:discount].blank?

    @product = Product.new(permitted_params)

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

    params[:product][:img_product] = @product.img_product if params[:product][:img_product].blank?
    params[:product][:discount] = 0 if params[:product][:discount].blank?

    respond_to do |format|
      if @product.update_attributes(permitted_params)
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

  private
  def permitted_params
    params.require(:product).permit(:title, :brand, :value_type, :value_price, :user_id, :category_id, :img_product, :description, :filters, :discount, :status) if current_user.role.to_i == 1
  end
end
