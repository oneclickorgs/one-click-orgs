require 'rails_helper'

describe 'directors/coop/index' do

  let(:task) {mock_model(Task, :to_partial_name => 'task_election_view_result')}

  before(:each) do
    @directors = [
      mock_model(Member, :to_param => '4', :id => 4,
        :gravatar_url => nil,
        :name => "Lisa Baker",
        :directorship => @directorship = mock_model(Directorship, :to_param => '5', :elected_on => 1.week.ago),
        :officership => nil
      ),
      mock_model(Member,
        :name => "John Smith",
        :gravatar_url => nil,
        :directorship => mock_model(Directorship),
        :officership => @officership = mock_model(Officership,
          :to_param => '3',
          :elected_on => 1.week.ago,
          :office_title => "Treasurer"
        )
      )
    ]
    assign(:directors, @directors)

    assign(:tasks, [task])
    stub_template('tasks/_task_election_view_result' => 'task template')

    allow(view).to receive(:can?).and_return(false)
  end

  it "displays a list of director-related tasks for the current user" do
    render
    expect(rendered).to render_template('tasks/_task_election_view_result')
  end

  context "when user can edit the Officerships" do
    before(:each) do
      allow(view).to receive(:can?).with(:edit, @officership).and_return(true)
    end

    it "renders a 'Step down' button for each officer" do
      render
      expect(rendered).to have_selector("form[action='/officerships/3/edit']")
    end
  end

  context "when user can edit the Directorships" do
    before(:each) do
      allow(view).to receive(:can?).with(:edit, @directorship).and_return(true)
    end

    it "renders a 'Retire' button for each director" do
      render
      expect(rendered).to have_selector("form[action='/directorships/5/edit']")
    end
  end


  context "when user can create a Director" do
    before(:each) do
      allow(view).to receive(:can?).with(:create, Directorship).and_return(true)
    end

    it "renders an 'Appoint new Director' button" do
      render
      expect(rendered).to have_selector("form[action='/directorships/new'] input[type='submit'][value='Appoint new Director']")
    end
  end

  context "when user can create an Officership" do
    before(:each) do
      allow(view).to receive(:can?).with(:create, Officership).and_return(true)
    end

    it "renders an 'Appoint a new Officer' button" do
      render
      expect(rendered).to have_selector("form[action='/officerships/new'] input[type='hidden'][name='officer_id'][value='4']", visible: false)
    end
  end

end
