# Importing the Flask class to create an application instance
from flask import Flask

# Import blueprints from different backend modules, each handling a specific domain 
from backend.address import address_bp
from backend.brand import brand_bp
from backend.category import category_bp
from backend.taxes import tax_bp
from backend.order import order_bp
from backend.orderitem import order_item_bp
from backend.orderstatus import order_status_bp
from backend.payment import payment_bp
from backend.paymentstatus import payment_status_bp 
from backend.product import product_bp 
from backend.shippingdetail import shipping_detail_bp 
from backend.user import user_bp 
from backend.wishlist import wishlist_bp


# Create  an instance of the Flask class, which acts ad the central registry for the application
app = Flask(__name__)


# Registering blueprints with the Flask application instance 
# Each blueprint is responsible for handling routes related to its domain
# Note: All blueprints are registered with the same URL prefix '/'
app.register_blueprint(address_bp, url_prefix='/')
app.register_blueprint(brand_bp, url_prefix='/')
app.register_blueprint(category_bp, url_prefix='/')
app.register_blueprint(tax_bp, url_prefix='/')
app.register_blueprint(order_bp, url_prefix='/')
app.register_blueprint(order_item_bp, url_prefix='/')
app.register_blueprint(order_status_bp, url_prefix='/')
app.register_blueprint(payment_bp, url_prefix='/')
app.register_blueprint(payment_status_bp, url_prefix='/')
app.register_blueprint(product_bp, url_prefix='/')
app.register_blueprint(shipping_detail_bp, url_prefix='/')
app.register_blueprint(user_bp, url_prefix='/')
app.register_blueprint(wishlist_bp, url_prefix='/')


# Condition to check if the script is the main program and should be run 
# Starts the Flask application server with debuging enabled 
if __name__ == '__main__':
    app.run(debug=True)


"""
Install python - if you are using VSCode as your IDE, it will ask/recommend you to install it - do it. 


Install Flask:
pip install Flask

Verify Installation:
flask --version

Install mysql-connector-python:
pip install mysql-connector-python


"""