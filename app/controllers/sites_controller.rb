class SitesController < Spree::BaseController
  def show
    case params[:id]
    when "australia"
      session[:australia] = true
    when "new_zealand"
      session[:australia] = false
    end
    
    redirect_to root_path
  end
end
