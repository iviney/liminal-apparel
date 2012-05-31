class HomepageController < Spree::BaseController
  before_filter :force_html_format

  def index
    request.format = :html
    # @show_specials tells the view whether or not to show the link to specials - i.e. if there are any
    @show_specials = false
    if t = Taxon.find(:first,:conditions=>{:permalink=>'categories/specials'})
      @show_specials = t.products.available.count > 0
    end
  end

  private
    def force_html_format
      request.format = :html
    end
end
