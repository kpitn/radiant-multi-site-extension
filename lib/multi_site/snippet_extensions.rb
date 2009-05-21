module MultiSite::SnippetExtensions
  def self.included(base)
    base.class_eval do
      before_save  :set_website
      mattr_accessor :current_site
      belongs_to :site
    end
    base.extend ClassMethods
  end
  
  module ClassMethods

  end

  def set_website
    self.site_id=self.current_site.id
  end


end
