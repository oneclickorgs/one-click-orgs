require 'spec_helper'

describe Clause do
  before(:each) do
    @old_objectives = Clause.make(
      :name => 'objectives', 
      :started_at => (Time.now - 3.days), 
      :ended_at => (Time.now - 1.day), 
      :text_value => "consuming ice-cream"
    )
    
    @current_objectives = Clause.make(
      :name => 'objectives',
      :started_at => (Time.now - 1.day),
      :text_value => "consuming doughnuts"
    )
    
    @current_voting_period = Clause.make(
      :name => 'voting_period',
      :started_at => (Time.now - 1.day),
      :integer_value => 1
    )
  end
  
  describe "get_current" do
    it "should find the current objectives" do
      Clause.get_current('objectives').should == @current_objectives
    end
  end
  
  describe "creating a new clause" do
    before(:each) do
      @c = Clause.new(:name => 'objectives', :text_value => 'consuming chocolate')
      @c.save
    end
    
    it "should set the started_at timestamp automatically" do
      @c.started_at.should_not be_nil
    end
    
    it "should end the clause that is being replaced" do
      @current_objectives.reload
      @current_objectives.ended_at.should_not be_nil
    end
  end
end
