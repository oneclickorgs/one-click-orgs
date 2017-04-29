require 'rails_helper'

describe "registration_forms/edit.html.haml" do

  let(:organisation) {mock_model(Coop,
    :reg_form_timing_factors => nil,
    :reg_form_financial_year_end => nil,
    :reg_form_close_links => nil,
    :reg_form_signatories => nil,
    :reg_form_signatories_attributes= => nil,
    :reg_form_main_contact_name => nil,
    :reg_form_main_contact_organisation_name => nil,
    :reg_form_main_contact_address => nil,
    :reg_form_main_contact_phone => nil,
    :reg_form_main_contact_email => nil,
    :reg_form_financial_contact_name => nil,
    :reg_form_financial_contact_phone => nil,
    :reg_form_financial_contact_email => nil,
    :reg_form_money_laundering_agreement => nil,
    :reg_form_money_laundering_0_name => nil,
    :reg_form_money_laundering_0_date_of_birth => nil,
    :reg_form_money_laundering_0_address => nil,
    :reg_form_money_laundering_0_postcode => nil,
    :reg_form_money_laundering_0_residency_length => nil,
    :reg_form_money_laundering_1_name => nil,
    :reg_form_money_laundering_1_date_of_birth => nil,
    :reg_form_money_laundering_1_address => nil,
    :reg_form_money_laundering_1_postcode => nil,
    :reg_form_money_laundering_1_residency_length => nil,
    :reg_form_funding => nil,
    :reg_form_members_benefit => nil,
    :reg_form_members_participate => nil,
    :reg_form_members_control => nil,
    :reg_form_profit_use => nil
  )}
  let(:members) {[
    mock_model(Member, :id => 111, :name => 'Angie', :selected => nil),
    mock_model(Member, :id => 222, :name => 'Bob', :selected => nil),
    mock_model(Member, :id => 333, :name => 'Christine', :selected => nil)
  ]}

  before(:each) do
    assign(:members, members)
    assign(:registration_form, organisation)
  end

  it "renders checkboxes to select signatories from the founder members" do
    render

    expect(rendered).to have_selector("input[type='checkbox'][name='registration_form[reg_form_signatories_attributes][0][selected]']")
    expect(rendered).to have_selector("label[for='registration_form_reg_form_signatories_attributes_0_selected']")
    expect(rendered).to have_selector("input[type='hidden'][name='registration_form[reg_form_signatories_attributes][0][id]'][value='111']", visible: false)

    expect(rendered).to have_selector("input[type='checkbox'][name='registration_form[reg_form_signatories_attributes][1][selected]']")
    expect(rendered).to have_selector("label[for='registration_form_reg_form_signatories_attributes_1_selected']")
    expect(rendered).to have_selector("input[type='hidden'][name='registration_form[reg_form_signatories_attributes][1][id]'][value='222']", visible: false)

    expect(rendered).to have_selector("input[type='checkbox'][name='registration_form[reg_form_signatories_attributes][2][selected]']")
    expect(rendered).to have_selector("label[for='registration_form_reg_form_signatories_attributes_2_selected']")
    expect(rendered).to have_selector("input[type='hidden'][name='registration_form[reg_form_signatories_attributes][2][id]'][value='333']", visible: false)
  end

  it "renders text fields for the main Co-operatives UK contact" do
    render

    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_main_contact_organisation_name]']")
    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_main_contact_name]']")
    expect(rendered).to have_selector("textarea[name='registration_form[reg_form_main_contact_address]']")
    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_main_contact_phone]']")
    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_main_contact_email]']")
  end

  it "renders text fields for the financial Co-operatives UK contact" do
    render

    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_financial_contact_name]']")
    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_financial_contact_phone]']")
    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_financial_contact_email]']")
  end

  it "renders text fields for the money laundering contacts' information" do
    render

    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_money_laundering_0_name]']")
    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_money_laundering_0_date_of_birth]']")
    expect(rendered).to have_selector("textarea[name='registration_form[reg_form_money_laundering_0_address]']")
    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_money_laundering_0_postcode]']")
    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_money_laundering_0_residency_length]']")
    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_money_laundering_1_name]']")
    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_money_laundering_1_date_of_birth]']")
    expect(rendered).to have_selector("textarea[name='registration_form[reg_form_money_laundering_1_address]']")
    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_money_laundering_1_postcode]']")
    expect(rendered).to have_selector("input[type='text'][name='registration_form[reg_form_money_laundering_1_residency_length]']")
  end

  it "renders a checkbox to agree with the money laundering form" do
    render

    expect(rendered).to have_selector("input[type='checkbox'][name='registration_form[reg_form_money_laundering_agreement]']")
  end

end
