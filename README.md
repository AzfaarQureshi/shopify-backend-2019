# Azfaar Qureshi 2019 Shopify backend challenge

## Features:

* Validate auth token for each request 
	* Currently generating tokens myself but in a production environment I'd use something like [JWT](https://jwt.io/))
* Access-role scoped GraphQL Queries 
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

## Documentation
### Queries:
* allProducts(available_inventory_only: Boolean): ![Product]
	* `available_inventory_only` is an optional flag with which only products with 
### Mutations:
