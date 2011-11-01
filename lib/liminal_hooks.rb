class LiminalHooks < Spree::ThemeSupport::HookListener
  insert_before :admin_product_form_right, :partial => "admin/shared/product_currency_prices"
  insert_before :admin_order_show_details, :partial => "admin/orders/screen_printing"
  replace :products_list_item, :partial => "shared/products_list_item"
end
