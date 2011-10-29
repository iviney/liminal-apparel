OrdersController.class_eval do
  def populate_with_screen_printing
    populate_without_screen_printing

    if params[:screen_printing]
      @order.update_attribute(:screen_printing, true)
    end
  end

  if instance_method_names.include?("populate")
    alias_method_chain :populate, :screen_printing
  end
end