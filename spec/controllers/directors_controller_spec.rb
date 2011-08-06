require 'spec_helper'

describe DirectorsController do
  
  include ControllerSpecHelper
  
  before(:each) do
    stub_app_setup
    stub_company
    stub_login
  end
  
  describe "POST create" do
    before(:each) do
      @director_parameters = double("director parameters")
      @director = mock_model(Director, :save => true).as_new_record
      @director.stub(:send_new_director_notifications)
      @company.stub(:build_director).and_return(@director)
    end
    
    def post_create
      post :create, 'director' => @director_parameters
    end
    
    it "builds a new director" do
      @company.should_receive(:build_director).with(@director_parameters).and_return(@director)
      post_create
    end
    
    it "saves the new director" do
      @director.should_receive(:save).and_return(true)
      post_create
    end
    
    it "sends notification emails to all directors" do
			@director.should_receive(:send_new_director_notifications)
      post_create
    end
    
    it "redirects to the members page" do
      post_create
      response.should redirect_to('/members')
    end
    
    context "when director cannot be saved" do
      it "handles the error gracefully"
    end
    
    it "checks permissions"
  end
  
end
