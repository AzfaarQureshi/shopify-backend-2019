# Azfaar Qureshi 2019 Shopify backend challenge

## Features:

* Made with Ruby on Rails and GraphQL
* Validate auth token for each request 
	* Currently generating tokens myself but in a production environment I'd use something like [JWT](https://jwt.io/))
* Access-role scoped Queries 
	* only an `Admin_User` can create or delete a product
* Create & sign in with Users
	* using bcrypt gem to encrypt passwords
	* each user has their own token which uniquely identifies them and their access-scope
* Unit-tests for basic functionality
	* Creating user, signing in with a user, creating/purchasing/deleting products
* Purchase products through cart
	* flow goes: createCart -> addProductsToCart -> checkoutCart

## Demo

The demo is available at [azfaarshopify2019.herokuapp.com](http://azfaarshopify2019.herokuapp.com/). 

_PS: since Heroku automatically sleeps free-tier applications it might take a minute to connect_

This section will walk you through the functionality of the API. The `Documentation` section further below will go more in depth about the specifics of the API

### 1. LandingPage
When you click the [demo link](http://azfaarshopify2019.herokuapp.com/) you should see a page like:
![LandingPage.png](https://i.imgur.com/ruxVnEb.png)

The disclaimer is that, if you skipped through the documentation, you'll know that all **all queries** except the **createUser** or **signinUser** will return an authorization error because

Click the `/graphiql` link to proceed

### 2. /Graphiql
![Graphiql page](https://i.imgur.com/dq53P8l.png)

This page is exposed for the purposes of demonstration and so that you can interact with the API easily.

1. Currently, you are not signed in as anyone. If you try to make a query you will the following error: `"Not Authorized to make this request."`
	* Try the following Query: 
		```GraphQL
			{
			  allProducts {
			    title
			    price
			    inventory_count
			  }
			}
		 ```
	  you should get the response:
	  ![unauthorized query response](https://i.imgur.com/Nuy37zq.png)

2. Before we can start using the API we have to `sign in`. There is support in the code to add more auth providers but for purposes of demonstration this application is using email & password for authentication. In a production environment we could have used google or another third party as an OAUTH provider
	* There are two USER_ROLES
		* `PUBLIC_USER`: can only *"get"* information from the API
		* `ADMIN_USER`: has all privileges of the API (i.e creating a product, deleting a product)
	* To create a user type the following:
		```GraphQL
		mutation {
		  createUser (
		    name:"First Name",
		    authProvider: {
		      email:{
			email:"example@example.com",
			password: "password"
		      }
		    },
		    role: [ADMIN_USER] # Alternatively, [PUBLIC_USER]
		  ) {
			email
			id
			name
			role
		  }
		}
		```
	  you should get a response like this:
	  ![create user response](https://i.imgur.com/GOnmke8.png)
	  
	* Now we signin with the following: 
		```GraphQL
		mutation {
		  signinUser(email: {
		    email: "example@example.com",
		    password: "password"
		  }) {
		    token
		    user {
		      email
		      id
		      name
		      role
		    }
		  }
		}
		```
	   You should see the following:
	   ![token creation](https://i.imgur.com/bKKe5nj.png)
	   
	   The token need not be saved anywhere, its already saved to the session. The API returns the token for the purposes of demonstration
	* Now that we're signed in, lets try the same query as before!
		```GraphQL
			{
			  allProducts {
			    title
			    price
			    inventory_count
			  }
			}
		 ```
	  and now we get:
	  ![actual response]()
		
## Documentation

### GraphQL Schema:

### Queries:
* allProducts(available_inventory_only: Boolean): ![Product]
	* `available_inventory_only` is an optional flag with which only products with 
### Mutations:

### User authentication
