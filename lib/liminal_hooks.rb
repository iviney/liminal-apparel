class LiminalHooks < Spree::ThemeSupport::HookListener

  insert_before :admin_product_form_right, :partial => "admin/shared/product_currency_prices"

  insert_before :admin_order_show_details, :partial => "admin/orders/screen_printing"

  insert_after :admin_orders_index_headers do # see spree_core-0.50.4\app\views\admin\orders\index.html.erb
     %( <th><%= sort_link @search, :currency, t("currency") %></th>)
  end

  insert_after :admin_orders_index_rows do
    %(<td><%= order.currency %></td>)
  end

  replace :products_list_item, :partial => "shared/products_list_item"
end
