module MultiSite::PagesControllerExtensions
  def self.included(base)
    base.class_eval {
        before_filter :set_site, :only=>[:show]
    }
  end

protected

  def set_site
    Page.current_site=@current_site
    Snippet.current_site=@current_site
  end

end
