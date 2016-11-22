require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @coach = User.create(first_name: "Travis", last_name: "Apples", email: "apples@gmail.com", encrypted_password: Devise::Encryptor.digest(User, 'password'), phone_number: "9999999999", is_coach: true)
  end
  test "admin should get index" do
    sign_in users(:admin)
    get users_url
    assert_equal "/users", path
  end

  test "guest shouldn't get index" do
    get users_url
    assert_redirected_to "/users/sign_in", path
  end

  test "coach shouldn't get index" do
    post '/users/sign_in', params: {user:{email: @coach.email, password: @coach.password}}
    get users_url
    assert_redirected_to "/users/sign_in", path
  end

  test "admin should get new" do
    sign_in users(:admin)
    get new_user_url
    assert_response :success
  end

  test "admin should be able to create" do
    sign_in users(:admin)
    post users_url, params: {user:{first_name: "Travis", last_name: "Apples", email: "apples@gmail.com", encrypted_password: Devise::Encryptor.digest(User, 'password'), phone_number: "9999999999"}}

    assert_redirected_to "/users", path
  end

  test "should get edit" do
    sign_in users(:admin)
    get edit_user_url(users(:admin))
    assert_response :success
  end

  test "should get update" do
    sign_in users(:admin)
    put users_url, params: {user:{id: users(:admin)}}
    assert_response :success
  end

  test "should get destroy" do
    sign_in users(:admin)
    delete "/users/#{users(:admin).id}"
    assert_redirected_to "/users"
  end

end
