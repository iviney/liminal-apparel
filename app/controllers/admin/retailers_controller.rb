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
end
