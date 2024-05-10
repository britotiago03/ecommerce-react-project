from flask import Blueprint, jsonify, request
from .database import db_connection 

wishlist_bp = Blueprint('wishlist', __name__)

@wishlist_bp.route('/wishlists', methods=['POST'])
def create_wishlist():
    data = request.json
    try:
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO Wishlist (UserID, ProductID, AddedDate, Name)
            VALUES (%s, %s, %s, %s)""",
            (data['UserID'], data['ProductID'], data['AddedDate'], data['Name']))
        conn.commit()
        return jsonify({'message': 'Wishlist item created successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@wishlist_bp.route('/wishlists', defaults={'wishlist_id': None})
@wishlist_bp.route('/wishlists/<int:wishlist_id>', methods=['GET'])
def get_wishlists(wishlist_id):
    try:
        conn = db_connection()
        cursor = conn.cursor(dictionary=True, buffered=True)
        if wishlist_id is not None:
            cursor.execute("""
                SELECT w.*, u.Username, p.Name AS ProductName
                FROM Wishlist w
                JOIN User u ON w.UserID = u.UserID
                JOIN Product p ON w.ProductID = p.ProductID
                WHERE w.WishlistID = %s""", (wishlist_id,))
            wishlist_item = cursor.fetchone()
            if wishlist_item:
                return jsonify(wishlist_item)
            else:
                return jsonify({'message': 'Wishlist item not found'}), 404
        else:
            cursor.execute("""
                SELECT w.*, u.Username, p.Name AS ProductName
                FROM Wishlist w
                JOIN User u ON w.UserID = u.UserID
                JOIN Product p ON w.ProductID = p.ProductID""")
            wishlist_items = cursor.fetchall()
            return jsonify(wishlist_items)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

@wishlist_bp.route('/wishlists/<int:wishlist_id>', methods=['PUT'])
def update_wishlist(wishlist_id):
    data = request.json
    try:
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            UPDATE Wishlist 
            SET UserID=%s, ProductID=%s, AddedDate=%s, Name=%s
            WHERE WishlistID=%s""",
            (data['UserID'], data['ProductID'], data['AddedDate'], data['Name'], wishlist_id))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No wishlist item found to update'}), 404
        conn.commit()
        return jsonify({'message': 'Wishlist item updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@wishlist_bp.route('/wishlists/<int:wishlist_id>', methods=['DELETE'])
def delete_wishlist(wishlist_id):
    try:
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Wishlist WHERE WishlistID=%s", (wishlist_id,))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No wishlist item found to delete'}), 404
        conn.commit()
        return jsonify({'message': 'Wishlist item deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()
