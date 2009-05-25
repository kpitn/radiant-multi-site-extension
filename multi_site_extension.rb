require_dependency 'application_controller'
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/multi_site/pages_controller_extensions"

class MultiSiteExtension < Radiant::Extension
  version "0.8.0"
  description %{ Enables virtual sites to be created with associated domain names.
                 Also scopes the sitemap view to any given page (or the root of an
                 individual site). }
  url "http://radiantcms.org/"

  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :sites, :member => {
        :move_higher => :post,
        :move_lower => :post,
        :move_to_top => :put,
        :move_to_bottom => :put
      }
    end
  end


  def activate
    # ActionController::Routing modules are required rather than sent as includes
    # because the routing persists between dev. requests and is not compatible
    # with multiple alias_method_chain calls.
    require 'multi_site/route_extensions'
    require 'multi_site/route_set_extensions'
    
    Page.send :include, MultiSite::PageExtensions
    SiteController.send :include, MultiSite::SiteControllerExtensions
    ApplicationController.send :include,  MultiSite::ApplicationControllerExtensions
    Admin::SnippetsController.send :include,  MultiSite::SnippetsControllerExtensions
    Snippet.send :include,  MultiSite::SnippetExtensions
    
    #Admin::PagesController.send :include, MultiSite::AdminPagesControllerExtensions
    #PagesController.send :include, MultiSite::PagesControllerExtensions
    
    admin.pages.index.add :top, "site_subnav"
    admin.tabs.add "Sites", "/admin/sites", :visibility => [:admin]
  end

  def deactivate
    admin.tabs.remove "Sites"
  end

end
