Product.delete_all
Product.create title: 'Samsung Galaxy S9', price: 999.99, inventory_count: 500
Product.create title: 'Papermate pens (10 pack)', price: 12.50, inventory_count: 70
Product.create title: 'Wireless mouse', price: 40.00, inventory_count: 0
Product.create title: 'Banana Pudding', price: 12.00, inventory_count: 1

OrderItem.delete_all
CartStatus.create id:1, name: "In Progress"
CartStatus.create id:2, name: "Completed"