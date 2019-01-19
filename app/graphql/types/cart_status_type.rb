Types::CartStatusType = GraphQL::ObjectType.define do
	name 'CartStatus'

	#Fields of CartStatus
	field :id, !types.ID
	field :name, !types.String
end