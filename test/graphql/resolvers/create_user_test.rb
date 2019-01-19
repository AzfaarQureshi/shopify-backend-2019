require 'test_helper'

class Resolvers::CreateUserTest < ActiveSupport::TestCase
  def perform(args = {})
    Resolvers::CreateUser.new.call(nil, args, nil)
  end

  test 'creating new user' do
    user1 = perform(
      name: 'Example Admin User',
      role: "ADMIN_USER",
      authProvider: {
        email: {
          email: 'test@example.com',
          password: 'Some Password'
        }
      }
    )
    user2 = perform(
      name: 'Example Public User',
      authProvider: {
        email: {
          email: 'example@example.com',
          password: 'Some Password'
        }
      }
    )

    assert user1.persisted?
    assert_equal user1.name, 'Example Admin User'
    assert_equal user1.email, 'test@example.com'
    assert_equal user1.role, "ADMIN_USER"

    assert user2.persisted?
    assert_equal user2.name, 'Example Public User'
    assert_equal user2.email, 'example@example.com'
    assert_equal user2.role, "PUBLIC_USER"
  end
end