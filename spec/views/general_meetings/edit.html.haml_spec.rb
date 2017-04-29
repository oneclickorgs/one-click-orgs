require 'rails_helper'

describe 'general_meetings/edit' do

  let(:general_meeting) {mock_model(GeneralMeeting,
    :resolutions => resolutions,
    :passed_resolutions_attributes= => nil,
    :agenda_items => agenda_items,
    :agenda_items_attributes= => nil,
    :participant_ids => []
  )}
  let(:members) {[
    mock_model(Member, :id => 1, :name => "John Smith"),
    mock_model(Member, :id => 2, :name => "Sally Baker")
  ]}
  let(:resolutions) {[
    mock_model(Resolution, :title => 'Resolution number 1', :passed => nil, :id => 3000, :additional_votes_for => nil, :additional_votes_against => nil),
    mock_model(Resolution, :title => 'Resolution number 2', :passed => nil, :id => 3001, :additional_votes_for => nil, :additional_votes_against => nil),
    mock_model(Resolution, :title => 'Resolution number 3', :passed => nil, :id => 3002, :paused? => true, :additional_votes_for => nil, :additional_votes_against => nil)
  ]}
  let(:agenda_items) {[
    mock_model(AgendaItem, :id => 4000, :title => "Apologies for Absence")
  ]}

  before(:each) do
    assign(:general_meeting, general_meeting)
    assign(:members, members)
  end

  it "renders a minutes field for each of the agenda items" do
    render
    expect(rendered).to have_selector("input[name='general_meeting[agenda_items_attributes][0][id]'][value='4000']", visible: false)
    expect(rendered).to have_selector("label[for='general_meeting_agenda_items_attributes_0_minutes']", text: 'Apologies for Absence')
    expect(rendered).to have_selector("textarea[name='general_meeting[agenda_items_attributes][0][minutes]']")
  end

  it "renders a minutes text area" do
    render
    expect(rendered).to have_selector("textarea[name='general_meeting[minutes]']")
  end

  it "renders a checkbox for each member" do
    render

    expect(rendered).to have_selector("input[type='checkbox'][name='general_meeting[participant_ids][1]']")
    expect(rendered).to have_selector("label[for='general_meeting_participant_ids_1']", text: "John Smith")

    expect(rendered).to have_selector("input[type='checkbox'][name='general_meeting[participant_ids][2]']")
    expect(rendered).to have_selector("label[for='general_meeting_participant_ids_2']", text: "Sally Baker")
  end

  it "renders a list of the attached resolutions' titles" do
    render
    expect(rendered).to have_content('Resolution number 1')
    expect(rendered).to have_content('Resolution number 2')
  end

  it "renders a 'passed' checkbox for each attached resolution" do
    render

    expect(rendered).to have_selector("input[name='general_meeting[passed_resolutions_attributes][0][passed]'][value='1']")
    expect(rendered).to have_selector("input[type='hidden'][name='general_meeting[passed_resolutions_attributes][0][id]'][value='3000']", visible: false)

    expect(rendered).to have_selector("input[name='general_meeting[passed_resolutions_attributes][1][passed]'][value='1']")
    expect(rendered).to have_selector("input[type='hidden'][name='general_meeting[passed_resolutions_attributes][1][id]'][value='3001']", visible: false)
  end

  it "renders vote count text fields for each attached resolution that was open for electronic voting" do
    render

    expect(rendered).to have_selector("input[name='general_meeting[passed_resolutions_attributes][2][additional_votes_for]']")
    expect(rendered).to have_selector("input[name='general_meeting[passed_resolutions_attributes][2][additional_votes_against]']")
  end

  it "renders a submit button" do
    render
    expect(rendered).to have_selector("input[type='submit']")
  end

end
