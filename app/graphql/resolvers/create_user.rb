class Resolvers::CreateUser < GraphQL::Function
  AuthProviderInput = GraphQL::InputObjectType.define do
    name 'AuthProviderSignupData'

    argument :email, Types::AuthProviderEmailInput
  end
  RoleEnum =  GraphQL::EnumType.define do
    name "UserRoles"
    description "List of user access roles"
    value("PUBLIC_USER", "Can only get information from api")
    value("ADMIN_USER", "Has all privileges to api")
  end

  argument :name, !types.String
  argument :authProvider, !AuthProviderInput
  argument :role, types[RoleEnum]

  type Types::UserType

  def call(_obj, args, _ctx)
      User.create!(
      name: args[:name],
      role: args[:role] || "PUBLIC_USER",
      email: args[:authProvider][:email][:email],
      password: args[:authProvider][:email][:password]
    )
  end
end