module ApplicationHelper
  def link_to_other_site
    if australia?
      link_to "Go to New Zealand Store (NZD)", site_path("new_zealand"), :class => "other-site"
    else
      link_to "Go to Australian Store (AUD)", site_path("australia"), :class => "other-site"
    end
  end
end
