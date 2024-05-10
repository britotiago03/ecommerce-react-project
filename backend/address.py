# Import necessary modules from Flask and the local database connection utility.
from flask import Blueprint, jsonify, request
from .database import db_connection  # Import database connection setup from the local module.

# Create a Blueprint named 'address' for all address-related routes.
address_bp = Blueprint('address', __name__)

# Define a route for creating new addresses using HTTP POST.
@address_bp.route('/addresses', methods=['POST'])
def create_address():
    data = request.json         # Parse JSON data from the request body.
    try:
        conn = db_connection()  # Establish a new database connection.
        cursor = conn.cursor()  # Create a cursor object to execute SQL commands.
                                # SQL command to insert a new address into the database.
        cursor.execute("""
            INSERT INTO Address (UserID, Street, City, State, PostalCode, Country, IsDefault, AddressType)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)""",
            (data['UserID'], data['Street'], data['City'], data['State'], data['PostalCode'], data['Country'], data['IsDefault'], data['AddressType']))
        conn.commit()           # Commit the transaction to save the changes.
                                # Return a success message with HTTP status 201.
        return jsonify({'message': 'Address created successfully'}), 201
    except Exception as e:      # Return an error message with HTTP status 500 if an exception occurs.
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()          # Ensure the cursor is closed after operation.
        conn.close()            # Ensure the connection is closed after operation.

# Define a route to retrieve all addresses using HTTP GET.
@address_bp.route('/addresses', methods=['GET'])
def get_addresses():
    try:
        conn = db_connection()  
        cursor = conn.cursor(dictionary=True)   # Use a dictionary cursor to return data in a dictionary format.
        cursor.execute("SELECT * FROM Address") # SQL command to select all records from the address table.
        addresses = cursor.fetchall()           # Fetch all results as a list of dictionaries.
        return jsonify(addresses)               # Return the list of addresses as JSON.
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Define a route to retrieve a specific address by ID using HTTP GET.
@address_bp.route('/addresses/<int:address_id>', methods=['GET'])
def get_address_by_id(address_id):
    try:
        conn = db_connection()
        cursor = conn.cursor(dictionary=True)
                                                # SQL command to select an address by ID.
        cursor.execute("SELECT * FROM Address WHERE AddressID = %s", (address_id,))
        address = cursor.fetchone()             # Fetch the first result.
        if address:
            return jsonify(address)             # Return the address as JSON if found.
        else:                                   # Return a not found message with HTTP status 404.
            return jsonify({'message': 'No address found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Define a route to update an existing address by ID using HTTP PUT.
@address_bp.route('/addresses/<int:address_id>', methods=['PUT'])
def update_address(address_id):
    data = request.json
    try:
        conn = db_connection()
        cursor = conn.cursor()
                                                # SQL command to update an address record by ID.
        cursor.execute("""
            UPDATE Address SET UserID=%s, Street=%s, City=%s, State=%s, PostalCode=%s, Country=%s, IsDefault=%s, AddressType=%s
            WHERE AddressID=%s""",
            (data['UserID'], data['Street'], data['City'], data['State'], data['PostalCode'], data['Country'], data['IsDefault'], data['AddressType'], address_id))
        if cursor.rowcount == 0:                # If no rows were affected, return a not found message.
            return jsonify({'message': 'No address found to update'}), 404
        conn.commit()                           # Return a success message.
        return jsonify({'message': 'Address updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# Define a route to delete an address by ID using HTTP DELETE.
@address_bp.route('/addresses/<int:address_id>', methods=['DELETE'])
def delete_address(address_id):
    try:
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Address WHERE AddressID = %s", (address_id,))
        if cursor.rowcount == 0:                # If no rows were affected, return a not found message.
            return jsonify({'message': 'No address found to delete'}), 404
        conn.commit()                           # Return a success message.
        return jsonify({'message': 'Address deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()
