Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  field :allProducts, !types[Types::ProductType] do
    argument :available_inventory_only, types.Boolean
    resolve -> (obj, args, ctx) {
      if(args[:available_inventory_only])
        puts "REACHING ME!"
        return Product.where("inventory_count > ? ", 0)
      else
        return Product.all
      end
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
