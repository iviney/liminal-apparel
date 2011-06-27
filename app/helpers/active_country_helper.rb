module ActiveCountryHelper
  def active_country
    return Country.find_by_name("New Zealand") if new_zealand?
    return Country.find_by_name("Australia") if australia?
  end
  
  def new_zealand?
    request.host.ends_with?(Site.domains[:new_zealand])
  end
  
  def australia?
    request.host.ends_with?(Site.domains[:australia])
  end
end
