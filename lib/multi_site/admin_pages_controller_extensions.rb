module MultiSite::AdminPagesControllerExtensions
  def self.included(base)
    base.class_eval {
      alias_method_chain :index, :root
      alias_method_chain :continue_url, :site
      alias_method_chain :remove, :back
      responses.destroy.default do 
        return_url = session[:came_from]
        session[:came_from] = nil
        redirect_to return_url || admin_pages_url(:root => model.root.id)
      end
    }
  end

  def index_with_root
    #Find website path by domain
    @site=Site.first(:conditions=>["base_domain=?",request.host])
    if @site
      @homepage = @site.homepage
    else
      #Find website path by root params
       if params[:root]
        @homepage = Page.find(params[:root])
        @site = @homepage.root.site
       end
        if @site.nil?
          #Find first website
          @site = Site.first(:order => "position ASC") # If there is a site defined
          if @site.homepage
            @homepage = @site.homepage
          end
        end
    end
    @homepage ||= Page.find_by_parent_id(nil)
    response_for :plural
  end

  def remove_with_back
    session[:came_from] = request.env["HTTP_REFERER"]
    remove_without_back
  end
  
  def continue_url_with_site(options={})
    options[:redirect_to] || (params[:continue] ? edit_admin_page_url(model) : admin_pages_url(:root => model.root.id))
  end
end
