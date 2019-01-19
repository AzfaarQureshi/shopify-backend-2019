Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  field :allProducts, !types[Types::ProductType] do
    resolve -> (obj, args, ctx) {
      Product.all
    }
  end 

  field :getProduct, Types::ProductType do
    argument :id, !types.ID
    resolve -> (obj, args, ctx) {
      return Product.find(args[:id])
    }
  end
end
