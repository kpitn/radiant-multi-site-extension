module MultiSite::SiteControllerExtensions
  def self.included(base)
    base.class_eval {
        before_filter :set_site, :only=>[:show_page]
    }
  end

protected

  def set_site
    Logger.new(STDOUT).info("TESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSST")
    Page.current_site=@current_site
    Snippet.current_site=@current_site
  end

end