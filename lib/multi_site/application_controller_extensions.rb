module MultiSite::ApplicationControllerExtensions
  
  def self.included(base)
    base.class_eval do
      before_filter :set_site
    end
  end

  def set_site
     @current_site=Site.first(:conditions=>["base_domain=?",request.host])
     return if @current_site.nil?
     
     Radiant::Config['admin.title'] = @current_site.name
     Radiant::Config['admin.subtitle'] = @current_site.subtitle
  end

end