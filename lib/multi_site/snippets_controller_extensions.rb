module MultiSite::SnippetsControllerExtensions
  def self.included(base)
    base.class_eval do
      before_filter :set_snippet_site
    end
  end

  def set_snippet_site
    Snippet.current_site = @current_site
    true
  end

  def index
    @snippets=Snippet.find_all_by_site_id(@current_site.id)
  end
  
end