class HomepageController < Spree::BaseController
  def index
    # @show_specials tells the view whether or not to show the link to specials - i.e. if there are any
    @show_specials = false
    if t = Taxon.find(:first,:conditions=>{:permalink=>'categories/specials'})
      @show_specials = t.products.available.count > 0
    end
  end
end
