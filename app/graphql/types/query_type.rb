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
      if(Product.exists?(args[:id]))
        return Product.find(args[:id])
      else
        return GraphQL::ExecutionError.new "Product does not exist with id: #{args[:id]}"
      end
    }
  end
end
