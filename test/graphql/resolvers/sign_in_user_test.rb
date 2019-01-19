require 'test_helper'

class Resolvers::SignInUserTest < ActiveSupport::TestCase
  def perform(args = {})
    Resolvers::SignInUser.new.call(nil, args, { session: {} })
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
end