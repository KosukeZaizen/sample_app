require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest


  def setup
    @user = users(:michael)
  end


  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_select '.alert'
    get root_path
    assert flash.empty?
    assert_select '.alert', false
  end


  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'pass2019' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end


end
