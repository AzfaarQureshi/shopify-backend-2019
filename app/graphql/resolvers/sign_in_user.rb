class Resolvers::SignInUser < GraphQL::Function
  argument :email, !Types::AuthProviderEmailInput

  # defining the return type inline here
  type do
    name 'SignInReturnType'

    field :token, types.String
    field :user, Types::UserType
  end

  def call(_obj, args, ctx)
    input = args[:email]

    return GraphQL::ExecutionError.new "Email parameter must be given" unless input

    user = User.find_by(email: input[:email])

    return GraphQL::ExecutionError.new "Invalid username or password" unless user
    return GraphQL::ExecutionError.new "Invalid username or password" unless user.authenticate(input[:password])

    # Just some basic token creation for the purposes of demonstration.
    # For a real application I'd use something like JWT for token creation
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base.byteslice(0..31))
    token = crypt.encrypt_and_sign("user-id:#{ user.id }")

    ctx[:session][:token] = token

    OpenStruct.new({
      user: user,
      token: token
    })
  end
end