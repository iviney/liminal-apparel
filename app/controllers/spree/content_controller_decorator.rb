ContentController.class_eval do

  # This is for those pages that need some extra preparation

  def community_retail
    @retailers = Retailer.retailers_for(active_country.name)
    render :action => 'community/retail'
  end

  def shop_retail
    @retailers = Retailer.retailers_for(active_country.name)
    render :action => 'shop/retail'
  end
end
