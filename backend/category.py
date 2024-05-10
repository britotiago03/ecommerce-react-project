from flask import Blueprint, jsonify, request
from flask_cors import CORS
from .database import db_connection

category_bp = Blueprint('category', __name__)
CORS(category_bp)

@category_bp.route('/categories', methods=['POST'])
def create_category():
    data = request.json
    if not data or 'Name' not in data or 'Description' not in data:
        return jsonify({'error': 'Missing required fields'}), 400

    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500

        cursor = conn.cursor()
        cursor.execute("INSERT INTO Category (Name, Description) VALUES (%s, %s)", (data['Name'], data['Description']))
        conn.commit()
        return jsonify({'message': 'Category created successfully'}), 201
    except Exception as e:
        return jsonify({'error': 'Failed to create category', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@category_bp.route('/categories', defaults={'category_id': None})
@category_bp.route('/categories/<int:category_id>', methods=['GET'])
def get_categories(category_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500

        cursor = conn.cursor(dictionary=True)
        if category_id is not None:
            cursor.execute("SELECT * FROM Category WHERE CategoryID = %s", (category_id,))
            category = cursor.fetchone()
            if category:
                return jsonify(category)
            else:
                return jsonify({'message': 'Category not found'}), 404
        else:
            cursor.execute("SELECT * FROM Category")
            categories = cursor.fetchall()
            return jsonify(categories)
    except Exception as e:
        return jsonify({'error': 'Failed to retrieve categories', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@category_bp.route('/categories/<int:category_id>', methods=['PUT'])
def update_category(category_id):
    data = request.json
    if not data or 'Name' not in data or 'Description' not in data:
        return jsonify({'error': 'Missing required fields'}), 400

    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500

        cursor = conn.cursor()
        cursor.execute("UPDATE Category SET Name = %s, Description = %s WHERE CategoryID = %s", (data['Name'], data['Description'], category_id))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No category found to update'}), 404

        conn.commit()
        return jsonify({'message': 'Category updated successfully'})
    except Exception as e:
        return jsonify({'error': 'Failed to update category', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@category_bp.route('/categories/<int:category_id>', methods=['DELETE'])
def delete_category(category_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500

        cursor = conn.cursor()
        cursor.execute("DELETE FROM Category WHERE CategoryID = %s", (category_id,))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No category found to delete'}), 404

        conn.commit()
        return jsonify({'message': 'Category deleted successfully'})
    except Exception as e:
        return jsonify({'error': 'Failed to delete category', 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()
