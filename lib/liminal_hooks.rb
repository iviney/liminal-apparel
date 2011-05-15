class LiminalHooks < Spree::ThemeSupport::HookListener
  insert_before :admin_product_form_right, :partial => "admin/shared/product_currency_prices"
end
