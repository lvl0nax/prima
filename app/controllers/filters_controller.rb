# -*- encoding : utf-8 -*-
class FiltersController < ApplicationController
  def index
    if !is_admin?
      redirect_to root_url
    else
      @filters = Filter.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @filters }
      end
    end
  end

  def create_filter
    if !is_admin?
      respond_to do |format|
        format.json { render :json => {
          :status => 0
        }}
      end
    else
      filter = Filter.new
      filter.name = params[:name]
      filter.values = params[:values]
      filter.main_flag = false
      respond_to do |format|
        if filter.save
          format.json { render :json => {
            :status => 1
          }}
        else
            format.json { render :json => {
              :status => 0
            }}
        end
      end
    end
  end

  def destroy_filter
    if !is_admin?
      respond_to do |format|
        format.json { render :json => {
          :status => 0
        }}
      end
    else
      filter = Filter.find_by_id(params[:id])
      filter.destroy
      respond_to do |format|
        format.json { render :json => {
          :status => 1
        }}
      end
    end
  end

  def add_value
    filter = Filter.find_by_id(params[:id])
    filter.values = params[:string]
    filter.save
    respond_to do |format|
        format.json { render :json => {
          :status => 1
        }}
    end
  end

  def change_name
    filter = Filter.find_by_id(params[:id])
    params[:filter] = {}
    params[:filter][:name] = params[:name]
    respond_to do |format|
      if filter.update_attributes(params[:filter])
        format.json { render :json => {
          :status => 1
        }}
      else
        format.json { render :json => {
          :status => 0
        }}

      end
    end
  end

  def change_flag
    filter = Filter.find_by_id(params[:id])
    flag = filter.main_flag == true ? false : true
    respond_to do |format|
      if filter.update_attributes(:main_flag => flag)
        format.json { render :json => {
          :status => 1,
          :checked => flag
        }}
      end
    end
  end

end
