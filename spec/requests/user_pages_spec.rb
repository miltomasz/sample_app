require 'spec_helper'

describe "User Pages" do
  subject { page }
  
  describe "sign up page" do
  	before { visit signup_path }

  	it { should have_selector('h1', text: 'Sign up') }
  	it { should have_selector('title', text: full_title('Sign up')) } 
  end

  describe "profile page" do
	  let(:user) { FactoryGirl.create(:user) }
	  before { visit user_path(user) }

	  it { should have_selector('h1',    text: user.name) }
	  it { should have_selector('title', text: user.name) }
	end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        describe "with no data given" do
          before do 
            click_button submit 
          end

          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }          
        end

        describe "with no name given" do
          before do 
            fill_in "Email",        with: "user@example.com"
            fill_in "Password",     with: "foobar"
            fill_in "Confirmation", with: "foobar"
            click_button submit 
          end
          it { should have_content("Name can't be blank") }
          it { should_not have_content("Email can't be blank") }
        end

        describe "with invalid email given" do
          before do 
            fill_in "Name",         with: "Example User"
            fill_in "Email",        with: "user@example"
            fill_in "Password",     with: "foobar"
            fill_in "Confirmation", with: "foobar"
            click_button submit 
          end

          it { should have_content("Email is invalid") }
        end

        describe "with too short password given" do
          before do 
            fill_in "Name",         with: "Example User"
            fill_in "Email",        with: "user@example.com"
            fill_in "Password",     with: "foo"
            fill_in "Confirmation", with: "foo"
            click_button submit 
          end

          it { should have_content("Password is too short") }
        end

        describe "with password confirmation mismatched" do
          before do 
            fill_in "Name",         with: "Example User"
            fill_in "Email",        with: "user@example.com"
            fill_in "Password",     with: "foobar1"
            fill_in "Confirmation", with: "foobar2"
            click_button submit 
          end

          it { should have_content("Password doesn't match confirmation") }
        end
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end
end
