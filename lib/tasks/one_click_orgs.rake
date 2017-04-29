require 'securerandom'
require 'fileutils'

# Returns an absolute filename given path elements relative to the config directory
def config_dir(*path_elements)
  path_elements.unshift(File.expand_path('../../../config', __FILE__))
  File.join(path_elements)
end

namespace :oco do
  desc "Generate installation-specific config files for One Click Orgs."
  task :generate_config do
    if File.exist? config_dir('database.yml')
      STDOUT.puts "config/database.yml already exists"
    else
      STDOUT.puts "Creating config/database.yml"
      FileUtils.cp config_dir('database.yml.sample'), config_dir('database.yml')
    end

    if File.exist? config_dir('initializers', 'local_settings.rb')
      STDOUT.puts "config/initializers/local_settings.rb already exists"
    else
      STDOUT.puts "Creating config/initializers/local_settings.rb"
      FileUtils.cp config_dir('initializers', 'local_settings.rb.sample'), config_dir('initializers', 'local_settings.rb')

      code = File.read(config_dir('initializers', 'local_settings.rb'))
      code.sub!('YOUR_SECRET_HERE', SecureRandom.hex(64))
      File.open(config_dir('initializers', 'local_settings.rb'), 'w'){|file| file << code}
    end
  end

  desc "Generate a list of contributors"
  task :contributors do
    File.open('doc/CONTRIBUTORS.txt', 'w') do |file|
      file << `git shortlog -nse`.gsub(/^\s+\d+\s+/, '')
    end
  end

  desc "Install wkhtmltopdf static binary for Linux"
  task :install_wkhtmltopdf do
    BASE_URL = "https://downloads.wkhtmltopdf.org/0.12/0.12.4/"
    ARCHIVE_NAME = "wkhtmltox-0.12.4_linux-generic-amd64.tar.xz"
    `wget #{BASE_URL}#{ARCHIVE_NAME}`
    `tar -xvjf #{ARCHIVE_NAME}`
    `mkdir -p vendor/bin`
    `mv wkhtmltox/bin/wkhtmltopdf vendor/bin`
    File.open(config_dir('initializers', 'local_settings.rb'), 'a') do |file|
      file.puts "PDFKit.configuration.wkhtmltopdf = '#{File.expand_path('../../../vendor/bin/wkhtmltopdf', __FILE__)}'"
    end
  end

  namespace :dev do
    namespace :association do
      desc "Create an active association, for development/testing purposes"
      task :create_active => :environment do
        unless OneClickOrgs::Setup.complete?
          STDERR.puts <<-EOE

  You must go through the application setup process before creating an
  association.

  Start the application server (e.g. 'bundle exec rails server')
  and visit the site in your browser (usually at http://localhost:3000 ).
          EOE
          exit
        end

        password = ENV['PASSWORD'] || "password"

        require 'spec/support/blueprints'

        association = Association.make!(
          :subdomain => Faker::Internet.domain_word
        )
        association.active!

        member_class = association.member_classes.find_by_name("Member")
        members = association.members.make!(3,
          :member_class => member_class,
          :password => password,
          :password_confirmation => password
        )

        # TODO Should we make a passed FoundAssociationProposal as well,
        # for total authenticity?

        STDOUT.puts "Association '#{association.name}' created:"
        STDOUT.puts "  #{association.domain}"
        STDOUT.puts "Log in with:"
        STDOUT.puts "  Email: #{members.first.email}"
        STDOUT.puts "  Password: #{password}"
      end

      desc "Create a pending association, for development/testing purposes"
      task :create_pending => :environment do
        unless OneClickOrgs::Setup.complete?
          STDERR.puts <<-EOE

  You must go through the application setup process before creating an
  association.

  Start the application server (e.g. 'bundle exec rails server')
  and visit the site in your browser (usually at http://localhost:3000 ).
          EOE
          exit
        end

        password = ENV['PASSWORD'] || "password"

        require 'spec/support/blueprints'

        association = Association.make!(:pending,
          :subdomain => Faker::Internet.domain_word
        )

        founder_member_class = association.member_classes.find_by_name("Founder")
        founder = association.members.make!(
          :member_class => founder_member_class,
          :password => password,
          :password_confirmation => password
        )

        founding_member_member_class = association.member_classes.find_by_name("Founding Member")
        founding_member = association.members.make!(2,
          :member_class => founding_member_member_class,
          :password => password,
          :password_confirmation => password
        )

        STDOUT.puts "Pending association '#{association.name}' created:"
        STDOUT.puts "  #{association.domain}"
        STDOUT.puts "Login for the founder"
        STDOUT.puts "  Email: #{founder.email}"
        STDOUT.puts "  Password: #{password}"
        STDOUT.puts "Login for a founding member"
        STDOUT.puts "  Email: #{founding_member.first.email}"
        STDOUT.puts "  Password: #{password}"
      end
    end

    namespace :coop do
      desc "Creates a Coop instance for testing, populated with some useful data"
      task :create_test_instance => :environment do
        unless OneClickOrgs::Setup.complete?
          STDERR.puts "Error: The application is not yet set up."
          exit
        end

        # Don't send emails
        ActiveRecord::Base.observers.disable :decision_mailer_observer, :directorship_mailer_observer, :meeting_mailer_observer, :member_mailer_observer, :officership_mailer_observer, :proposal_mailer_observer

        password = ENV['password'] || "password"

        number_to_create = ENV['NUMBER'] ? ENV['NUMBER'].to_i : 1

        require 'spec/support/blueprints'

        subdomain_index = 0

        number_to_create.times do
          # Find first available test subdomain
          subdomain_index += 1
          while Organisation.find_by_subdomain("test#{subdomain_index}")
            subdomain_index += 1
          end

          coop = Coop.make!(
            :created_at => 12.months.ago,
            :subdomain => "test#{subdomain_index}",
            :name => "The Locally-Grown Co-operative",
            :registered_office_address => "1 High Street, Broxbourne",
            :objectives => "produce locally-grown food."
          )

          # Members for logging in

          secretary = coop.members.make!(:secretary,
            :first_name => "Sally",
            :last_name => "Secretary",
            :email => "secretary@example.com",
            :password => password,
            :password_confirmation => password,
            :inducted_at => 12.months.ago,
            :state => 'active'
          )

          coop.offices.find_by_title("Secretary").officership = Officership.make!(
            :officer => secretary
          )

          member = coop.members.make!(:member,
            :first_name => "Max",
            :last_name => "Member",
            :email => "member@example.com",
            :password => password,
            :password_confirmation => password,
            :inducted_at => 10.months.ago
          )

          # Other members

          coop.members.make!(:director,
            :first_name => "James",
            :last_name => "Godwin",
            :email => "james@example.com",
            :inducted_at => 12.months.ago,
            :state => 'active'
          )

          coop.members.make!(:member,
            :first_name => "Caroline",
            :last_name => "Jones",
            :email => "caroline@example.com",
            :inducted_at => 6.months.ago
          )

          coop.members.make!(15, :member, :inducted_at => 7.months.ago)

          coop.general_meetings.make!(
            :happened_on => 5.days.ago,
            :created_at => (5+14).days.ago,
            :venue => "The function room at the Royal Oak",
            :start_time => "6.30pm",
            :minutes => nil
          )

          coop.general_meetings.make!(
            :happened_on => 4.days.from_now,
            :created_at => (4.days.from_now - 14.days),
            :venue => "The Meeting Hall",
            :start_time => "7pm",
            :agenda => "Discuss the new shop premises."
          )

          STDOUT.puts "Coop '#{coop.subdomain}' created:"
          STDOUT.puts "  #{coop.domain}"
        end

        ActiveRecord::Base.observers.enable :decision_mailer_observer, :member_mailer_observer, :officership_mailer_observer, :proposal_mailer_observer
      end

      desc "Creates a co-op for demo purposes, populated with a decent amount of history"
      task :create_demo_instance => :environment do
        unless OneClickOrgs::Setup.complete?
          STDERR.puts "Error: The application is not yet set up."
          exit
        end

        # Don't send emails
        ActiveRecord::Base.observers.disable :decision_mailer_observer, :directorship_mailer_observer, :meeting_mailer_observer, :member_mailer_observer, :officership_mailer_observer, :proposal_mailer_observer

        password = ENV['password'] || "password"

        number_to_create = ENV['NUMBER'] ? ENV['NUMBER'].to_i : 1

        require 'spec/support/blueprints'
        require 'faker'

        subdomain_index = 0

        number_to_create.times do
          # Find first available test subdomain
          subdomain_index += 1
          while Organisation.find_by_subdomain("demo#{subdomain_index}")
            subdomain_index += 1
          end

          coop = Coop.make!(
            :created_at => 12.months.ago,
            :subdomain => "demo#{subdomain_index}",
            :name => "The Locally-Grown Co-operative",
            :registered_office_address => "1 High Street, Broxbourne",
            :objectives => "produce locally-grown food."
          )

          # Members for logging in

          secretary = coop.members.make!(:secretary,
            :first_name => "Sally",
            :last_name => "Secretary",
            :email => "secretary@example.com",
            :password => password,
            :password_confirmation => password,
            :inducted_at => 12.months.ago,
            :state => 'active'
          )

          coop.offices.find_by_title("Secretary").officership = Officership.make!(
            :officer => secretary
          )

          member = coop.members.make!(:member,
            :first_name => "Max",
            :last_name => "Member",
            :email => "member@example.com",
            :password => password,
            :password_confirmation => password,
            :inducted_at => 10.months.ago
          )

          # Other members

          coop.members.make!(:director,
            :first_name => "James",
            :last_name => "Godwin",
            :email => "director@example.com",
            :inducted_at => 12.months.ago,
            :state => 'active'
          )

          coop.members.make!(:member,
            :first_name => "Caroline",
            :last_name => "Jones",
            :email => "caroline@example.com",
            :inducted_at => 6.months.ago
          )

          coop.members.make!(15, :member, :inducted_at => 7.months.ago)

          # Give each member at least one share
          coop.members.reload
          coop.members.all.each do |member|
            st = ShareTransaction.make!(
              :to_account => member.find_or_create_share_account,
              :from_account => coop.share_account,
              :amount => rand(5) + 1
            )
            st.save!
            st.approve!
          end

          # History of past meetings

          1.upto(4) do |index|
            meeting = coop.general_meetings.make!(
              :happened_on => (index * 2).months.ago,
              :created_at => (index * 2).months.ago - 14.days,
              :venue => "The function room at the Royal Oak",
              :start_time => "7pm"
            )
            meeting.agenda_items.each do |agenda_item|
              agenda_item.minutes = Faker::Lorem.paragraph
              agenda_item.save!
            end
            meeting.participants << coop.members.sample(10)
            Task.where(:subject_type => 'Meeting', :subject_id => meeting.id).each(&:complete!)
          end

          # Upcoming AGM

          # A resolution for the AGM

          resolution = coop.resolutions.build(
            :title => "Open a second shop",
            :description => "The co-operative should open a second shop in the south of town.",
            :draft => true
          )
          resolution.proposer = secretary
          resolution.save!

          agm = coop.annual_general_meetings.make!(
            :happened_on => 2.weeks.from_now,
            :created_at => 3.weeks.ago,
            :venue => "The Village Hall",
            :start_time => "7pm",

            :electronic_voting => true,
            :voting_closing_date => (2.weeks.from_now - 1.day)
          )
          agm.resolutions << resolution
          resolution.start!

          # Add some nominees
          election = agm.election
          nominees = coop.members.all
          nominees.reject!{|n| n.member_class.name == 'Director'}
          nominees.reject!{|n| n.member_class.name == 'Secretary'}
          nominees.delete(coop.members.find_by_email("member@example.com"))
          nominees = nominees[0..4]
          election.nominees = nominees
          election.save!

          election.start!

          # New membership application
          new_member = coop.members.make!(:state => 'pending')


          STDOUT.puts "Coop '#{coop.subdomain}' created."
        end

        ActiveRecord::Base.observers.enable :decision_mailer_observer, :member_mailer_observer, :officership_mailer_observer, :proposal_mailer_observer
      end

    end



    desc "Move aside any 'testx' instances."
    task :archive_test_instances => :environment do
      archived = []
      organisations = Organisation.where("subdomain LIKE 'test%'").all
      organisations.each do |o|
        original_subdomain = o.subdomain
        o.subdomain = "archived-#{Time.now.utc.to_s(:number)}-#{original_subdomain}"
        if o.save
          archived << "#{original_subdomain} -> #{o.subdomain}"
        else
          STDERR.puts "Could not archive instance '#{original_subdomain}'."
        end
      end
      if archived.empty?
        STDOUT.puts "Did not archive any instances."
      else
        STDOUT.puts "Archived these instances:"
        archived.each do |archive_line|
          STDOUT.puts archive_line
        end
      end
    end

    task :find_leaking_test => [:environment, 'db:test:prepare'] do
      Dir.glob('spec/**/*_spec.rb').each do |spec_path|
        STDOUT.puts "Running #{spec_path}"
        system("bundle exec rspec #{spec_path}")
        organisation_count = Organisation.count
        if organisation_count == 0
          STDOUT.puts "OK: left 0 organisations behind."
        else
          STDOUT.puts "FAIL: left #{organisation_count == 1 ? "1 organisation" : "#{organisation_count} organisations"} behind!"
        end
      end
    end
  end
end
