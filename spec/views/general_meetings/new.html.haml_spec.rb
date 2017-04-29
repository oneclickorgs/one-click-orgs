require 'rails_helper'

describe "general_meetings/new" do

  before(:each) do
    @general_meeting = mock_model(GeneralMeeting,
      :certification => nil,
      :existing_resolutions_attributes= => nil,
      :annual_general_meeting => nil,
      :electronic_nominations => nil,
      :nominations_closing_date => nil,
      :electronic_voting => nil,
      :voting_closing_date => nil,
      :start_time_proxy => nil,
      :agenda_items => [
        mock_model(AgendaItem, :title => "Apologies for Absence"),
        mock_model(AgendaItem, :title => "Minutes of Previous Meeting")
      ],
      :agenda_items_attributes= => nil
    ).as_new_record
    assign(:general_meeting, @general_meeting)

    @draft_resolutions = [
      mock_model(Resolution, :state => 'draft', :id => 111, :attached => nil, :open => nil),
      mock_model(Resolution, :state => 'draft', :id => 222, :attached => nil, :open => nil)
    ]
    assign(:draft_resolutions, @draft_resolutions)

    @directors_retiring = [
      mock_model(Director, :name => "Sally Baker"),
      mock_model(Director, :name => "John Smith")
    ]
  end

  it "renders time select fields for the start_time attribute" do
    render
    expect(rendered).to have_selector("select[name='general_meeting[start_time_proxy(4i)]']")
    expect(rendered).to have_selector("select[name='general_meeting[start_time_proxy(5i)]']")
  end

  it "renders the agenda items as text fields" do
    render
    expect(rendered).to have_selector("input[value='Apologies for Absence']")
    expect(rendered).to have_selector("input[value='Minutes of Previous Meeting']")
  end

  it "renders check boxes to attach draft resolutions to the new meeting" do
    render
    expect(rendered).to have_selector("input[name='general_meeting[existing_resolutions_attributes][0][attached]'][type='checkbox'][value='1']")
  end

  it "renders check boxes to mark attached draft resolutions as open for electronic voting" do
    render
    expect(rendered).to have_selector("input[name='general_meeting[existing_resolutions_attributes][0][open]'][type='checkbox'][value='1']")
  end

  it "renders a hidden field with the ID of each draft resolution" do
    render
    expect(rendered).to have_selector("input[name='general_meeting[existing_resolutions_attributes][0][id]'][value='111'][type='hidden']", visible: false)
  end

end
