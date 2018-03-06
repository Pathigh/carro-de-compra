class OrdersController < ApplicationController

	before_action :authenticate_user!



	def index
		@orders = current_user.orders.where(payed: false)
		@total = @orders.inject(0) {|total, order|total += order.product.price}
		@subtotal = @orders.inject(0) {|subtotal, order|subtotal += order.product.price * order.quantity}
		
	end

	def empty_card
		current_user.orders.destroy_all

		redirect_to orders_path, notice: 'Se ha vaciado el carro'
		
	end

	def destroy

			@order = Order.find(params[:id])

			if @order.quantity == 1

			   if @order.destroy

			   	redirect_to orders_path, notice: 'Carro Actualizado'
			   else
			   	redirect_to orders_path, alert: 'Error al actualizar'
			   end

			elsif @order.quantity > 1

				 @order.quantity -= 1

				 if @order.save

					redirect_to orders_path, notice: 'Carro Actualizado'
				else
					redirect_to orders_path, alert: 'Error al actualizar'
				end
			end
			
	end

	def create
        @previous_order = Order.find_by(user_id: current_user.id, product_id: params[:product_id], payed: false)

        if @previous_order.present?
            new_quantity = @previous_order.quantity + 1
            @previous_order.update(quantity: new_quantity)
            redirect_to root_path, notice: 'La orden se ha generado con exito'
        else
            @order = Order.new()
            @order.product = Product.find(params[:product_id])
            @order.user = current_user

        if @order.save
            redirect_to root_path, notice: 'El producto ha sido agregado al carro'
        else
            redirect_to root_path, alert: 'El producto no ha sido agregado al carro'    
        end
    end
 end

end
