module ApplicationHelper
  def link_to_other_site
    if australia?
      link_to "Go to New Zealand Store (NZD)", root_url(:host => Site.domains[:new_zealand], :port => request.port), :class => "other-site"
    else
      #TBD Enable this when Australian site is operational.
      #link_to "Go to Australian Store (AUD)", root_url(:host => Site.domains[:australia], :port => request.port), :class => "other-site"
    end
  end

  def shop_enabled
    true # false # setting this to false turns off the shopping aspects of the site
  end

end
