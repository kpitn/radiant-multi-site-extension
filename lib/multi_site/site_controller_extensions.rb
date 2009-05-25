module MultiSite::SiteControllerExtensions
  def self.included(base)
    base.class_eval {
        before_filter :set_site, :only=>[:show_page]
    }
  end

protected

#  def set_site
#    Page.current_site=@current_site
#    Snippet.current_site=@current_site
#  end

  def set_site
    @current_site = Site.find_for_host(request.host)
    Page.current_site=@current_site
    Snippet.current_site=@current_site
    true
  end
  
end