#require_dependency 'application'

class MultiSiteExtension < Radiant::Extension
  version "0.3"
  description %{ Enables virtual sites to be created with associated domain names.
                 Also scopes the sitemap view to any given page (or the root of an
                 individual site). }
  url "http://radiantcms.org/"

  define_routes do |map|
      map.resources :sites, :path_prefix => "/admin",
                  :member => {
                    :move_higher => :post,
                    :move_lower => :post,
                    :move_to_top => :put,
                    :move_to_bottom => :put
                  }
  end

  def activate
    # ActionController::Routing modules are required rather than sent as includes
    # because the routing persists between dev. requests and is not compatible
    # with multiple alias_method_chain calls.
    require 'multi_site/route_extensions'
    require 'multi_site/route_set_extensions'


  # Add site relation to snippet
    Snippet.class_eval do
      belongs_to :site
    end

    Page.send :include, MultiSite::PageExtensions
    SiteController.send :include, MultiSite::SiteControllerExtensions
    Admin::PagesController.send :include, MultiSite::PagesControllerExtensions
#    ResponseCache.send :include, MultiSite::ResponseCacheExtensions
    Radiant::Config["dev.host"] = 'preview' if Radiant::Config.table_exists?
    admin.pages.index.add :top, "site_subnav"
    admin.tabs.add "Sites", "/admin/sites", :visibility => [:admin]
  end

  def deactivate
    admin.tabs.remove "Sites"
  end

end
