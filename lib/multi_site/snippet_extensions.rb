module MultiSite::SnippetExtensions
  def self.included(base)
    base.class_eval do
      before_save  :set_website
      mattr_accessor :current_site
      belongs_to :site
      validates_uniqueness_of :name, :message => 'name already in use', :scope=> :site_id

      def self.find_by_name(name)
        snippet=Snippet.find(:first,:conditions=>{:name=>name,:site_id=>1})
        if !snippet
          snippet=Snippet.find(:first,:conditions=>{:name=>name})
        end
        return snippet
      end

    end
    base.extend ClassMethods
  end
  
  module ClassMethods


  end

  def set_website
    return if self.current_site.nil?
    self.site_id=self.current_site.id
  end


end
