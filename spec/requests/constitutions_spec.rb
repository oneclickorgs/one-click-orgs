require 'rails_helper'

describe "constitutions" do

  include RequestSpecHelper
  
  before(:each) do
    default_association
    default_association_constitution
    association_login
    set_permission!(@user, :constitution_proposal, true)
  end
  
  describe "GET edit" do
    before(:each) do
      get '/constitution/edit'
    end
    
    it "renders a form to create a constitution proposal bundle" do
      expect(page).to have_selector("form[action='/constitution_proposal_bundles']")
    end
    
    it "fills in the name field" do
      expect(page).to have_selector("input[name='constitution_proposal_bundle[organisation_name]'][value='#{@organisation.name}']")
    end
    
    it "fills in the objectives field" do
      expect(page).to have_selector("textarea[name='constitution_proposal_bundle[objectives]']", text: @organisation.objectives)
    end
    
    it "checks the correct assets radio button" do
      expect(page).to have_selector("input[name='constitution_proposal_bundle[assets]'][value='0'][checked='checked']")
    end
    
    it "checks the correct general voting system radio button" do
      expect(page).to have_selector("input[name='constitution_proposal_bundle[general_voting_system]'][value='RelativeMajority'][checked='checked']")
    end
    
    it "checks the correct membership voting system radio button" do
      expect(page).to have_selector("input[name='constitution_proposal_bundle[membership_voting_system]'][value='Veto'][checked='checked']")
    end
    
    it "checks the correct constitution voting system radio button" do
      expect(page).to have_selector("input[name='constitution_proposal_bundle[constitution_voting_system]'][value='AbsoluteTwoThirdsMajority'][checked='checked']")
    end
    
    it "checks the correct voting period radio button" do
      expect(page).to have_selector("input[name='constitution_proposal_bundle[voting_period]'][value='259200'][checked='checked']")
    end
    
    context "when organisation is pending" do
      before(:each) do
        association_is_pending
        set_permission!(@user, :founder, true)
        get '/constitution/edit'
      end
      
      it "renders a form to update the constitution" do
        expect(page).to have_selector("form[action='/constitution']") do |form|
          expect(form).to have_selector("input[name='_method'][value='put']", visible: false)
        end
      end
      
      it "fills in the name field" do
        expect(page).to have_selector("input[name='constitution[organisation_name]'][value='#{@organisation.name}']")
      end

      it "fills in the objectives field" do
        expect(page).to have_selector("textarea[name='constitution[objectives]']", text: @organisation.objectives)
      end

      it "checks the correct assets radio button" do
        expect(page).to have_selector("input[name='constitution[assets]'][value='0'][checked='checked']")
      end

      it "checks the correct general voting system radio button" do
        expect(page).to have_selector("input[name='constitution[general_voting_system]'][value='RelativeMajority'][checked='checked']")
      end

      it "checks the correct membership voting system radio button" do
        expect(page).to have_selector("input[name='constitution[membership_voting_system]'][value='Veto'][checked='checked']")
      end

      it "checks the correct constitution voting system radio button" do
        expect(page).to have_selector("input[name='constitution[constitution_voting_system]'][value='AbsoluteTwoThirdsMajority'][checked='checked']")
      end

      it "checks the correct voting period radio button" do
        expect(page).to have_selector("input[name='constitution[voting_period]'][value='259200'][checked='checked']")
      end
      
    end
  end
  
end
