require 'spec_helper'

describe "Micropost pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.should_not change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.should change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    let(:other_user) { FactoryGirl.create(:user) }
    let(:micropost) { FactoryGirl.create(:micropost, user:  other_user) }
    let(:logged_user_micropost) { FactoryGirl.create(:micropost, user:  user) }
    
    describe "as correct user" do
      before { FactoryGirl.create(:micropost, user:  user) }
      before { visit root_path }

      it "should delete a micropost" do
        expect { should have_link('delete', href: micropost_path(micropost)) }
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

    describe "as user which did not create micropost" do
      before { visit user_path(other_user) }

      it { should_not have_link('delete', href: micropost_path(micropost)) }
    end
  end

  describe "microposts pagination" do
    let(:user) { FactoryGirl.create(:user) }

    before(:all) { 31.times { FactoryGirl.create(:micropost, user: user) } }
    after(:all)  { user.delete }

    before do
      sign_in user
      visit user_path(user)
    end

    it { should have_selector('div.pagination') }

    it "should list each micropost" do
      Micropost.paginate(page: 1).each do |micropost|
        page.should have_selector('li', text: micropost.content)
      end
    end
  end
end
