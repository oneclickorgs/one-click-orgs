class Coop < Organisation
  has_many :board_meetings, :foreign_key => 'organisation_id'
  has_many :general_meetings, :foreign_key => 'organisation_id'
  
  has_many :resolutions, :foreign_key => 'organisation_id'
  
  def create_default_member_classes
    members = member_classes.find_or_create_by_name('Member')
    members.set_permission!(:resolution_proposal, true)
    members.set_permission!(:vote, true)
    
    founder_members = member_classes.find_or_create_by_name('Founder Member')
    
    directors = member_classes.find_or_create_by_name('Director')
    directors.set_permission!(:resolution, true)
    directors.set_permission!(:board_resolution, true)
    directors.set_permission!(:vote, true)
    
    secretaries = member_classes.find_or_create_by_name('Secretary')
    secretaries.set_permission!(:resolution, true)
    secretaries.set_permission!(:board_resolution, true)
    secretaries.set_permission!(:vote, true)
  end
  
  def set_default_voting_period
    constitution.set_voting_period(14.days)
  end
end