Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  field :allProducts, !types[Types::ProductType] do
    resolve -> (obj, args, ctx) {
      Product.all
    }

  end
end
