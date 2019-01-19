Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  # Product Mutators
  field :purchaseProduct, function: Resolvers::PurchaseProduct.new
  field :createProduct, function: Resolvers::CreateProduct.new
  field :deleteProduct, function: Resolvers::DeleteProduct.new

  # User Mutators
  field :createUser, function: Resolvers::CreateUser.new
  field :signinUser, function: Resolvers::SignInUser.new

  # Cart Mutators
  field :createCart, function: Resolvers::CreateCart.new
  field :addToCart, function: Resolvers::AddToCart.new
end
