# A convenience class to allow creation of a Member model object, but using
# 'Director.new' instead of 'Member.new'.
# 
# Adds some director-specific validation
class Director < Member
  @abstract_class = true
  
  attr_accessor :certification
  
  def send_new_director_notifications
		self.organisation.members.each do |member|
			MembersMailer.new_director_notification(member, self).deliver 
		end
	end
end
