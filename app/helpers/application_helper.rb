module ApplicationHelper
  include ProductsHelper
  
  def link_to_other_site
    if australia?
      link_to "Go to New Zealand Site (NZD)", root_url(:host => Site.domains[:new_zealand], :port => request.port), :class => "other-site"
    else
      #TBD Enable this when Australian site is operational.
      link_to "Go to Australian Site (AUD)", root_url(:host => Site.domains[:australia], :port => request.port), :class => "other-site"
    end
  end

end
