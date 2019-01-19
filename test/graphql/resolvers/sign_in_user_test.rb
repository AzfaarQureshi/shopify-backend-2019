require 'test_helper'

class Resolvers::SignInUserTest < ActiveSupport::TestCase
  def perform(args = {})
    Resolvers::SignInUser.new.call(nil, args, { cookies: {}})
  end

  setup do
    @user = User.create! name: 'sample name', email: 'sample@email.com', password: 'sampe password'
  end

  test 'creating token' do
    result = perform(
      email: {
        email: @user.email,
        password: @user.password
      }
    )

    assert result.present?
    assert result.token.present?
    assert_equal result.user, @user
  end

  test 'case: no credentials' do
    assert_nil perform
  end

  test 'case: wrong email' do
    assert_nil perform(email: { email: 'wrong' })
  end

  test 'case: wrong password' do
    assert_nil perform(email: { email: @user.email, password: 'wrong' })
  end
end