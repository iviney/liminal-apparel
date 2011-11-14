class Admin::RetailersController < Admin::BaseController
  resource_controller

  #TBD do we need this stuff?
  create.success.wants.html { redirect_to collection_url }
  update.success.wants.html { redirect_to collection_url }
  destroy.success.wants.js { render_js_for_destroy }

#  update.after :update_after
#  create.after :create_after

  private

  def update_after
    Rails.cache.delete('retailers')
  end

  def create_after
    Rails.cache.delete('retailers')
  end

  def collection # see https://github.com/ernie/meta_search/tree/250c71772d30546d1b4a4134f51035610b4ba0bc
    @search = Retailer.metasearch(params[:search])
  end

end
