require 'rails_helper'

feature "注册与登录", :type => :feature do

    scenario "登录与登出" do
        user = User.create!( :email => "wang.bb@rmit.edu.au", :password => "123456")
    
        visit "/users/sign_in"
    
        within("#new_user") do
          fill_in "Email", with: "wang.bb@rmit.edu.au"
          fill_in "Password", with: "123456"
        end
    
        click_button "Log in"  # 点击登入按钮
    
        expect(page).to have_content("Signed in successfully")
    
        click_link "登出"  # 点击主选单的登出超连结
    
        expect(page).to have_content("Signed out successfully")
      end
    

  scenario "注册测试" do
    visit "/users/sign_up"  # 浏览注册页面


    expect(page).to have_content("Sign up")

    within("#new_user") do  # 填表单

      fill_in "Email", with: "wang.bb@rmit.edu.au"
      fill_in "Password", with: "123456"
      fill_in "Password confirmation", with: "123456"
    end

    click_button "Sign up"
    # 检查文字。这文字是 Devise 默认会放在 flash[:notice] 上的

    expect(page).to have_content("Welcome! You have signed up successfully")

    # 检查数据库里面最后一笔真的有刚刚填的资料

    user = User.last
    expect(user.email).to eq("wang.bb@rmit.edu.au")
  end

end
