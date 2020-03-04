require 'rails_helper'

feature "停车费用计算", :type => :feature do

  scenario "短期停车计费" do
    user = User.create!( :email => "wang.bb@rmit.edu.au", :password => "123456")
    sign_in(user) # 这样就可以登入了


    visit "/"
    choose "短期费率"  # 选 radio button


    click_button "开始计费"

    click_button "结束计费"

    expect(page).to have_content("¥2.00")
  end

end