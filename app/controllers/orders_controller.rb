# -*- encoding : utf-8 -*-
class OrdersController < ApplicationController
    def index
      if is_admin?
        @orders = Order.all
      else
        redirect_to root_url
      end
    end

    def show
        @order = Order.find(params[:id])

        if(@order.userto_id != -1)
            @userTo = User.find_by_id(@order.userto_id)
        end

        @products = []

        @order.content.split(",").each do |arr_text|
          id = arr_text.split("|")[0]
          count = arr_text.split("|")[1]
          p = Product.find_by_id(id)
          p['count'] = count
          @products.push(p)
        end

        @user = User.find_by_id(@order.user_id)

        if (current_user && (current_user == @user || current_user == @userTo || !is_admin?))
        else
            redirect_to root_url
        end
    end

    def new
        if !cookies[:card].nil?
            @order = JSON.parse(cookies[:card])
            @order_users = []
            @order_users_obj = {}
            if(!@order.blank?)
              @order.each do |o|
                if(!@order_users.include?(o[1]['user']))
                  @order_users.push(o[1]['user'])
                end
              end
              @order_users_obj = User.find_all_by_id(@order_users)
            end
        end

        if @order.blank?
            redirect_to root_url
        end
    end

    def change_status
        @order = Order.find_by_id(params[:id])

        if current_user && current_user.id == @order.user_id
            @order.status = params["status"]
            @order.save

            render :json => {
                :status => 1
            }
        else
            render :json => {
                :status => 0
            }
        end
    end

  def create_order

      if !cookies[:card].nil?

            @order = JSON.parse(cookies[:card])

            @uriks = {} #Объект юридичиских лиц, которым будет рассылаться заказ

            @order.each do |o| #Группировка по юридическим лицам
                buffer = Product.find_by_id(o[0])
                buffer['count'] = (o[1]['count'])

                if (@uriks[buffer.user_id].nil?)
                    @uriks[buffer.user_id] = []
                end

                @uriks[buffer.user_id].push(buffer)
            end

            @order_for_fizik = Suborder.new #костыль для взятия id следующего подзаказа
            @order_for_fizik.save

            @order_ids = [] #будет хранить id заказов
            @status_order = [] #будет хранить статус заказов

            @uriks.each do |p|
                @order_for_urik = Order.new # Ордер хранит заказы атомные для юриков

                @order_for_urik.user_id = p[0]
                @order_for_urik.userto_id = current_user ? current_user.id : -1
                @order_for_urik.name = params[:fio]
                @order_for_urik.phone = params[:phone]
                @order_for_urik.date = params[:date]
                @order_for_urik.email = params[:email]
                @order_for_urik.address = params[:address]
                @order_for_urik.suborder_id = @order_for_fizik.id
                @order_for_urik.status = 0

                @order_for_urik.content = []

                total_price = 0

                p[1].each do |pr|
                    @order_for_urik.content.push( pr.id.to_s + "|" + pr.count.to_s)

                    if pr.discount != "0"
                        act_disc = 0
                        disc_arr = pr.discount.split("&")
                        discObj = {}
                        disc_arr.each do |discPar|
                          discObj[discPar.split(")*")[0]] = discPar.split(")*")[1]
                        end
                        discObj.each do |datom|
                          if(datom[0].to_f <= pr.count)
                            act_disc = datom[1].to_f
                          end
                        end
                        total_price += pr.count * (pr.value_price.to_f - (pr.value_price.to_f * act_disc) / 100)
                    else
                      total_price += pr.count * pr.value_price.to_f
                    end
                end

                @order_for_urik.total = total_price.to_s
                @order_for_urik.content = @order_for_urik.content.join(",")

                @order_for_urik.save
                @order_ids.push(@order_for_urik.id)
                @status_order.push(0)

            end

            # Здесь идёт заполнение заказа для физика
            @order_for_fizik.user_id = current_user ? current_user.id : -1
            @order_for_fizik.uriks = @order_ids.join("-")
            @order_for_fizik.status = @status_order.join("-")
            @order_for_fizik.save

            cookies[:card] = "" #обнуление корзины

            render :json => {
                :ids => @order_ids.join("-"),
                :count => @order_ids.count,
                :status => 1
            }

      end

      if @order.blank?
        render :json => {
            :status => 0
        }
      end
  end

end
