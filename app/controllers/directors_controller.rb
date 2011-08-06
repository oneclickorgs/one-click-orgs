class DirectorsController < ApplicationController
  def create
    @director = co.build_director(params[:director])
    if @director.save
			@director.send_new_director_notifications
		end
    redirect_to members_path
  end
end
