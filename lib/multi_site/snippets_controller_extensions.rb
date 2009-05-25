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
    if !@current_site.nil?
      @my_snippets=Snippet.find_all_by_site_id(@current_site.id)
      @snippets=Snippet.find(:all,:conditions=>{:site_id=>nil})
    else
      @snippets=Snippet.find(:all,:conditions=>{:site_id=>nil})
    end
  end

  def show
    @template_name = 'show'
    @snippet=Snippet.find(params[:id])
  end


  def new
    @snippet=Snippet.new({:site_id=>@current_site.id})
  end
end