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
	  ![actual response](https://i.imgur.com/afTZJFU.png)
	  
3. Types of Queries
	* Notice how the `Wireless mouse` product has inventory 0? We can filter that out with the following:
		```GraphQL
			{
			  allProducts(available_inventory_only: true) {
			    title
			    price
			    inventory_count
			    id
			  }
			}
		 ```
	  and now we do not get `wireless mouse` in our example:
	  ![no inventory items filtered out](https://i.imgur.com/TmWHCIH.png)
	* We can also get Products one at a time through their ID: 
	 	```GraphQL
		{
		  getProduct(id: 5){
		    id
		    title
		    price
		    inventory_count
		  }
		}
		```
	  and we get:
	  ![prod by id](https://i.imgur.com/lLix3Ya.png)
	  
	* We can try `getCart` but since we haven't created a cart yet, we should expect an error. Let's try it:
		```GraphQL
		{
		  getCart {
		    cart_status {
		      id
		      name
		    }
		    id
		    items {
		      price
		      title
		    }
		    subtotal
		  }
		}
		```
	  and as expected we get:
	  ![get cart](https://i.imgur.com/GdRqrfU.png)
	  
3. Mutators 
	* Let's begin by creating an active cart first. 
		```GraphQL
		mutation {
		  createCart {
		    cart_status {
		      id
		      name
		    }
		    id
		    items{
		      id
		      title
		      price
		    }
		    subtotal
		  }
		}
		```
	  and we get:
	  
	  ![create cart](https://i.imgur.com/0si5AKC.png)
	  
	  The cart will stay "In Progress" until we `checkout` the cart, and then it'll change to "Completed"
	* We can create a product with: 
		```GraphQL
		mutation {
			createProduct(
		    title: "mirror"
		    price: 5.0
		    inventory_count: 1
		  ) {
		    title
		    id
		    price
		    inventory_count
		  }
		}
		```
	![create product](https://i.imgur.com/cbkQG5v.png)
	
	* To demonstrate purchasing a product without having to go through creating a cart -> adding items to a cart -> completing a cart, I added a single `purchaseCart` function. We can also purchase products through the cart which we will do later. Let's purchase this product twice, to see what will happen when the inventory becomes 0.
	```GraphQL
	mutation {
	purchaseProduct(id: 9){
	    title
	    inventory_count
	    id
	    price
	  }
	}
	```
	notice how the `inventory_count`, which was 1 previously, decrements to 0:
	![purchase](https://i.imgur.com/y3ZNxlN.png)
	Running this again gives us an expected error as you cannot purchase a product with no inventory!
	![purchase no inventory](https://i.imgur.com/AAm3NPb.png)
	
	* Let's delete this product we just created.
	
	```GraphQL
	mutation {
	deleteProduct(id: 9){
	    title
	    price
	    inventory_count
	  }
	}
	```
	![delete prod](https://i.imgur.com/GtUOYqp.png)
	Lets just run it again to make sure it's deleted:
	![delete again](https://i.imgur.com/JQ1OA7B.png)
	
	* Now for purchasing products through the cart. First we must add products to the cart
## Documentation

### GraphQL Schema:

JUST ADD SCREENSHOTS

### Queries:

JUST ADD SCREENSHOTS

### Mutations:
JUST ADD SCREENSHOTS
