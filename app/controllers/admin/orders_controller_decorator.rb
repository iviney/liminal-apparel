Admin::OrdersController.class_eval do

  # Changed to default to showing only completed orders.  See spree_core-0.50.4\app\controllers\admin\orders_controller.rb#collection

  private

  def collection_with_default
    params[:search] ||= {}
    params[:search][:completed_at_is_not_null] ||= "1" # default to only show completed orders
    collection_without_default
  end

  alias_method_chain :collection, :default unless private_instance_methods.include?("collection_without_default")

end
