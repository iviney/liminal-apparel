module ActiveCountryHelper
  def active_country
    Country.find_by_name(australia? ? "Australia" : "New Zealand")
  end
  
  def new_zealand?
    !australia?
  end
  
  def australia?
    Site.australia?(request.host)
  end
end
