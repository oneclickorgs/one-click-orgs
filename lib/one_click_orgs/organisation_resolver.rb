require 'action_view/template/resolver'

module OneClickOrgs
  # OrganisationResolver is a custom template resolver that provides for
  # customisation of an entire template based on the kind of organisation
  # we are dealing with.
  # 
  # The resolver looks for customised templates in a subdirectory named after 
  # the name of the class you specify at initialisation time. If a customised
  # template cannot be found, it falls back to using the default template.
  # 
  # For instance, if you create a new OrganisationResolver like this:
  # 
  #   OrganisationResolver.new(Rails.root + '/app/views', Company)
  # 
  # and prepend the new resolver to your view paths, then an attempt to
  # render the +index+ action of the +people+ controller will try the
  # follwing templates in order until it finds one that exists:
  # 
  # * <tt>app/views/people/company/index</tt>
  # * <tt>app/views/people/index</tt>
  class OrganisationResolver < ActionView::FileSystemResolver
    # +path+ is a root template path on the file system
    # (e.g. <tt>Rails.root + '/app/views'</tt>).
    # 
    # +organisation_class+ is the Class for which you want to search for
    # customised templates.
    def initialize(path, organisation_class)
      super(path)
      @organisation_class_name = organisation_class.name.underscore
    end
    
  private
    
    def find_templates(name, prefix, partial, details, _)
      prefix_expansions = ["#{prefix}/#{@organisation_class_name}", prefix]
      templates = []
      prefix_expansions.each do |expanded_prefix|
        templates += super(name, expanded_prefix, partial, details)
      end
      templates
    end
  end
end
