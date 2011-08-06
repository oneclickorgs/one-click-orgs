class MembersMailer < OcoMailer
  def welcome_founder(member)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    raise ArgumentError, "No member provided" unless @member
    @organisation = member.organisation
    @organisation_name = member.organisation.name

    create_mail(@organisation_name, @member.email, "#{@organisation_name} on One Click Orgs")
  end
  
  def welcome_new_founding_member(member)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    raise ArgumentError, "No member provided" unless @member
    @organisation = member.organisation
    @organisation_name = member.organisation.name

    @founder = Member.founders(@organisation).first
    raise ArgumentError, "Organisation has no founder" unless @founder

    create_mail(@organisation_name, @member.email, "Become a founding member of #{@organisation_name}")
  end
  
  def welcome_new_member(member)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    raise ArgumentError, "No member provided" unless @member
    @organisation_name = member.organisation.name

    create_mail(@organisation_name, @member.email, "Invitation to become a member of #{@organisation_name}")
  end
  
  def password_reset(member)
    default_url_options[:host] = member.organisation.domain(:only_host => true)
    
    @member = member
    raise ArgumentError, "No member provided" unless @member
    @organisation_name = member.organisation.name

    create_mail(@organisation_name, @member.email, "Your password for #{@organisation_name} on One Click Orgs")
  end
  
  def new_director_notification(member, director)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    @director = director
    raise ArgumentError, "No member provided" unless @member
    @organisation = member.organisation
    @organisation_name = member.organisation.name

    create_mail(@organisation_name, @member.email, "Notification from #{@organisation_name} on One Click Orgs")
  end
  
  # TODO Implement @ directors_controller.rb -> destroy
  #def director_leaves_notification(member, director)
  #  default_url_options[:host] = member.organisation.domain(:only_host => true)

  #  @member = member
  #  raise ArgumentError, "No member provided" unless @member
  #  @organisation = member.organisation
  #  @organisation_name = member.organisation.name

  #  create_mail(@organisation_name, @member.email, "Notification from #{@organisation_name} on One Click Orgs")
  #end
end
