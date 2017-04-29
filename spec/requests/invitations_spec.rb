require 'rails_helper'

describe "invitations" do

  include RequestSpecHelper

  before(:each) do
    default_association(:state => 'pending')
    @member = @organisation.members.make!(:inducted_at => nil, :password => nil, :password_confirmation => nil, :state => 'pending')
  end
  
  describe "GET edit" do
    def get_edit
      get "/i/#{@member.invitation_code}"
    end
    
    it "is successful" do
      get_edit
      expect(response).to be_successful
    end
    
    it "renders a form to update the invitation" do
      get_edit
      expect(page).to have_selector("form[action='/invitations/#{@member.invitation_code}']") do |form|
        expect(form).to have_selector("input[name='_method'][value='put']", visible: false)
      end
    end
    
    it "shows fields to choose a password" do
      get_edit
      expect(page).to have_selector("input[name='invitation[password]']")
      expect(page).to have_selector("input[name='invitation[password_confirmation]']")
    end
    
    describe "rendering a hidden terms and conditions field" do
      it "renders a hidden terms and conditions field" do
        get_edit
        expect(page).to have_selector("input[name='invitation[terms_and_conditions]'][type='hidden']", visible: false)
      end
      
      it "sets the value to '0'" do
        get_edit
        expect(page).to have_selector("input[name='invitation[terms_and_conditions]'][value='0']", visible: false)
      end
    end
  end
  
  describe "PUT update" do
    def post_update
      put "/invitations/#{@member.invitation_code}", 'invitation' => {'password' => 'letmein', 'password_confirmation' => 'letmein', 'terms_and_conditions' => '1'}
    end
    
    it "saves the member's new password" do
      post_update
      @member.reload
      expect(@member.crypted_password).to be_present
      expect(@member.salt).to be_present
    end
    
    it "clears the member's invitation code" do
      post_update
      @member.reload
      expect(@member.invitation_code).to be_blank
    end
    
    it "logs in the user" do
      post_update
      expect(session[:user]).to eq(@member.id)
    end
    
    it "updates the user's last-logged-in-at timestamp" do
      post_update
      @member.reload
      expect(@member.last_logged_in_at).to be_present
    end
    
    it "redirects to the home page" do
      post_update
      expect(response).to redirect_to root_path
    end
  end
  
end
