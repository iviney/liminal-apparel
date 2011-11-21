OrdersController.class_eval do

  # ===================================================================================================================
  # Redirect access to orders if the shop is closed.
  before_filter :redirect_if_shop_closed

  # ===================================================================================================================
  # Redefine #populate
  def populate_with_screen_printing
    populate_without_screen_printing

    if params[:screen_printing]
      @order.update_attribute(:screen_printing, true)
    end
  end

  if !instance_method_names.include?("populate_without_screen_printing")
    alias_method_chain :populate, :screen_printing
  end

  # ===================================================================================================================
  # Redefine #show to add a check for valid parameters
  def show
    @order = Order.find_by_number(params[:id])
    if !@order
      redirect_to cart_path # if the parameters are scummed up (e.g. if a GET occurs instead of a PUT, avoid crashes)
    end
  end

  # ===================================================================================================================
  # Redirect access to orders if the shop is closed.
  private

  def redirect_if_shop_closed
    if !Spree::Config[:allow_purchasing]
      flash[:error] = t(:shop_is_closed)
      redirect_to root_path
    end
  end
end