from flask import Blueprint, jsonify, request
from flask_cors import CORS
from .database import db_connection

brand_bp = Blueprint('brand', __name__)
CORS(brand_bp)

@brand_bp.route('/')
def api_index():
    endpoints = {
        '/brand [POST]': 'Create a new brand',
        '/brand [GET]': 'Retrieve all brands',
        '/brand/<int:brand_id> [GET]': 'Retrieve a brand by ID',
        '/brand/<int:brand_id> [PUT]': 'Update a brand by ID',
        '/brand/<int:brand_id> [DELETE]': 'Delete a brand by ID',
    }
    return jsonify(endpoints)

@brand_bp.route('/brand', methods=['POST'])
def create_brand():
    data = request.json 
    try:
        
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Brand (Name, Description) VALUES (%s, %s)", (data['Name'], data['Description']))
        conn.commit()
        return jsonify({'message': 'Brand created successfully'}), 201
    except Exception as e:
        return jsonify({'error': 'Failed to create brand', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@brand_bp.route('/brand', defaults={'BrandID': None})
@brand_bp.route('/brand/<int:BrandID>', methods=['GET'])
def get_brand(BrandID):
    conn = db_connection()
    if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500


    cursor = conn.cursor(dictionary=True)
    if BrandID is not None:
        cursor.execute("SELECT * FROM Brand WHERE BrandID = %s", (BrandID,))
        brand = cursor.fetchone()
        if brand:
            return jsonify(brand)
        else:
            return jsonify({'message': 'Brand not found'}), 404
    else:
        cursor.execute("SELECT * FROM Brand")
        brands = cursor.fetchall()
        return jsonify(brands)

@brand_bp.route('/brand/<int:brand_id>', methods=['PUT'])
def update_brand(brand_id):
    try:
        data = request.json
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500

        cursor = conn.cursor()
        cursor.execute("UPDATE Brand SET Name = %s, Description = %s WHERE BrandID = %s", (data.get('Name'), data.get('Description'), brand_id))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No brand found to update'}), 404
        
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Brand updated successfully'})
    except Exception as e:
        return jsonify({'error': 'Failed to update brand', 'message': str(e)}), 500

@brand_bp.route('/brand/<int:brand_id>', methods=['DELETE'])
def delete_brand(brand_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Brand WHERE BrandID = %s", (brand_id,))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No brand found to delete'}), 404
        
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Brand deleted successfully'})
    except Exception as e:
        return jsonify({'error': 'Failed to delete brand', 'message': str(e)}), 500

