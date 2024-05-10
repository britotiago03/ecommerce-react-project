from flask import Blueprint, jsonify, request
from flask_cors import CORS
from .database import db_connection 

product_bp = Blueprint('product', __name__)
CORS(product_bp)

@product_bp.route('/products', methods=['POST'])
def create_product():
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO Product (Name, Description, Price, StockQuantity, BrandID, CategoryID, ImageURL, SKU, Weight, Dimensions, IsActive)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""",
            (data['Name'], data['Description'], data['Price'], data['StockQuantity'], data['BrandID'], 
             data['CategoryID'], data['ImageURL'], data['SKU'], data['Weight'], data['Dimensions'], data['IsActive']))
        conn.commit()
        return jsonify({'message': 'Product created successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@product_bp.route('/products', defaults={'product_id': None})
@product_bp.route('/products/<int:product_id>', methods=['GET'])
def get_products(product_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor(dictionary=True)
        if product_id is not None:
            cursor.execute("""
                SELECT p.*, b.Name AS BrandName, c.Name AS CategoryName
                FROM Product p
                JOIN Brand b ON p.BrandID = b.BrandID
                JOIN Category c ON p.CategoryID = c.CategoryID
                WHERE p.ProductID = %s""", (product_id,))
            product = cursor.fetchone()
            if product:
                return jsonify(product)
            else:
                return jsonify({'message': 'Product not found'}), 404
        else:
            cursor.execute("""
                SELECT p.*, b.Name AS BrandName, c.Name AS CategoryName
                FROM Product p
                JOIN Brand b ON p.BrandID = b.BrandID
                JOIN Category c ON p.CategoryID = c.CategoryID""")
            products = cursor.fetchall()
            return jsonify(products)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@product_bp.route('/products/category/<string:category_name>', methods=['GET'])
def get_products_by_category(category_name):
    conn = db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT p.*, b.Name as BrandName, c.Name as CategoryName 
            FROM Product p
            JOIN Category c ON p.CategoryID = c.CategoryID
            JOIN Brand b ON p.BrandID = b.BrandID
            WHERE c.Name = %s""", (category_name,))
        products = cursor.fetchall()
        return jsonify(products), 200
    except Exception as e:
        print(e)
        return jsonify({'error': 'Database connection failed'}), 500
    finally:
        cursor.close()
        conn.close()

# New route for searching products by name or brand
@product_bp.route('/products/search', methods=['GET'])
def search_products():
    search_query = request.args.get('query', default="", type=str).strip()
    selected_brand = request.args.get('brand', default="All Brands", type=str).strip()

    if not search_query and selected_brand == "All Brands":
        return jsonify({'message': 'No search criteria provided'}), 400

    conn = db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500

    cursor = conn.cursor(dictionary=True)
    try:
        sql_query = """
        SELECT p.*, b.Name AS BrandName, c.Name AS CategoryName
        FROM Product p
        JOIN Brand b ON p.BrandID = b.BrandID
        JOIN Category c ON p.CategoryID = c.CategoryID
        WHERE (p.Name LIKE %s OR b.Name LIKE %s)
        """
        sql_params = ['%' + search_query + '%', '%' + search_query + '%']

        # Filter by selected brand if not 'All Brands'
        if selected_brand != "All Brands":
            sql_query += " AND b.Name = %s"
            sql_params.append(selected_brand)

        cursor.execute(sql_query, sql_params)
        products = cursor.fetchall()
        return jsonify(products), 200
    except Exception as e:
        return jsonify({'error': 'Error processing your request', 'details': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@product_bp.route('/products/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("""
            UPDATE Product 
            SET Name=%s, Description=%s, Price=%s, StockQuantity=%s, BrandID=%s, CategoryID=%s, 
            ImageURL=%s, SKU=%s, Weight=%s, Dimensions=%s, IsActive=%s 
            WHERE ProductID=%s""",
            (data['Name'], data['Description'], data['Price'], data['StockQuantity'], data['BrandID'], 
             data['CategoryID'], data['ImageURL'], data['SKU'], data['Weight'], data['Dimensions'], data['IsActive'], product_id))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No product found to update'}), 404
        conn.commit()
        return jsonify({'message': 'Product updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@product_bp.route('/products/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Product WHERE ProductID=%s", (product_id,))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No product found to delete'}), 404
        conn.commit()
        return jsonify({'message': 'Product deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()
