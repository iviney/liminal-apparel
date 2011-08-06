class Site
  class_attribute :active_currency
  
  class_attribute :domains
  self.domains = {}
  
  class << self
    def new_zealand?(host)
      !australia?(host)
    end
    
    def australia?(host)
      host.ends_with?(domains[:australia])
    end
  end
end
