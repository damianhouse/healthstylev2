require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @coach = User.create(first_name: "Travis", last_name: "Apples", email: "apples@gmail.com", encrypted_password: Devise::Encryptor.digest(User, 'password'), phone_number: "9999999999", is_coach: true)
  end

  test "admin should get index" do
    sign_in users(:admin)
    get users_url
    assert_equal "/admin/users", path
  end

  test "guest shouldn't get index" do
    get users_url
    assert_redirected_to "/users/sign_in", path
  end

  test "coach shouldn't get index" do
    sign_in users(:coach)
    get users_url
    assert_redirected_to "/", path
  end

  test "admin should get new" do
    sign_in users(:admin)
    get new_user_url
    assert_response :success
  end

  test "admin should be able to create a user" do
    sign_in users(:admin)
    post users_url, params: {user:{first_name: "Travis", last_name: "Apples", email: "apples@gmail.com", encrypted_password: Devise::Encryptor.digest(User, 'password'), phone_number: "9999999999"}}

    assert_redirected_to "/admin/users", path
  end

  test "admin should be able to edit a user" do
    sign_in users(:admin)
    get edit_user_url(users(:user))
    assert_response :success

    put users_url, params: {user:{id: users(:user)}}
    assert_response :success
  end

  test "admin should be able to edit a coach" do
    sign_in users(:admin)
    get edit_user_url(users(:coach).id)
    assert_response :success

    put edit_user_url(users(:coach).id), params: {user:{id: users(:coach)}}
    assert_response :success
  end

  test "a coach can edit their information" do
    sign_in users(:coach)
    get edit_user_url(users(:coach))
    assert_response :success

    put users_url, params: {user:{id: users(:coach)}}
    assert_response :success
  end

  test "should get destroy" do
    sign_in users(:admin)
    delete "/admin/users/#{users(:admin).id}"
    assert_redirected_to "/admin/users"
  end
end
