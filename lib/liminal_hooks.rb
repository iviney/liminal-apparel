class LiminalHooks < Spree::ThemeSupport::HookListener

  insert_before :admin_product_form_right, :partial => "admin/shared/product_currency_prices"

  insert_before :admin_order_show_details, :partial => "admin/orders/screen_printing"

  # Add a column in admin order listing to show currency of order
  insert_after :admin_orders_index_headers do # see spree_core-0.50.4\app\views\admin\orders\index.html.erb
     %( <th><%= sort_link @search, :currency, t("currency") %></th>)
  end

  insert_after :admin_orders_index_rows do
    %(<td><%= order.currency %></td>)
  end

  # Add a column in admin product listing to show currency prices
  insert_after :admin_products_index_headers do
    %(<th><%= sort_link @search,:currency_prices, "Currency prices" %></th>)
  end

  insert_after :admin_products_index_rows do
    %(<td><%= product.currency_prices %></td>)
  end
  
  replace :products_list_item, :partial => "shared/products_list_item"

  # Add an admin item to maintain retailers  # see spree_core-0.50.4\app\views\admin\configurations\index.html.erb
  insert_after :admin_configurations_menu do
  <<HTML
  <tr>
    <td><%= link_to "Retailers", admin_retailers_path %></td>
    <td><%= "Maintain lists of retailers for different regions." %></td>
  </tr>
HTML
  end

  # Change order listing to include time on order date # see spree_core-0.50.4\app\views\admin\orders\index.html.erb
  replace :admin_orders_index_rows, :partial => 'admin/shared/orders_index_rows.html.erb'

  # Add an admin-only field to the shipping_methods admin forms (see spree_core-0.50.4/app/views/admin/shipping_methods/_form.html.erb)
  insert_after :admin_shipping_method_form_fields do
  <<HTML
  <%= f.field_container :admin_only do %>
    <label>
    <%= f.check_box(:admin_only)  %><%= t(show_method_to_admin_users_only) %>
    <br />
    </label>
  <% end %>
HTML
  end

  # Add admin-only column to listing of shipping methods in admin - see \spree_core-0.50.4\app\views\admin\shipping_methods\index.html.erb
  insert_after :admin_shipping_methods_index_headers do
    %(<th><%= t("admin_only") %></th>)
  end

  insert_after :admin_shipping_methods_index_rows do
    %(<td><%= shipping_method.admin_only ? "Yes" : "" %></td>)
  end
end
