class LineItemsController < Spree::BaseController
  def destroy
    if @order = current_order
      @line_item = current_order.line_items.find(params[:id])
      @line_item.destroy
      
      redirect_to cart_path
    end
  end
end
