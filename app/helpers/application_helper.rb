module ApplicationHelper
  def link_to_other_site
    if australia?
      link_to "Go to New Zealand Store (NZD)", root_url(:host => Site.domains[:new_zealand], :port => request.port), :class => "other-site"
    else
      link_to "Go to Australian Store (AUD)", root_url(:host => Site.domains[:australia], :port => request.port), :class => "other-site"
    end
  end
end
