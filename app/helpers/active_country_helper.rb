module ActiveCountryHelper
  def active_country
    Country.find_by_name(australia? ? "Australia" : "New Zealand")
  end

  def australia?
    request.host.ends_with?(".au") || params[:au]
  end
end
