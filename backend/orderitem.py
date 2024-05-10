from flask import Blueprint, jsonify, request
from .database import db_connection  

order_item_bp = Blueprint('order_item', __name__)

@order_item_bp.route('/orderitems', methods=['POST'])
def create_order_item():
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO OrderItem (OrderID, ProductID, Quantity, Subtotal)
            VALUES (%s, %s, %s, %s)""",
            (data['OrderID'], data['ProductID'], data['Quantity'], data['Subtotal']))
        conn.commit()
        return jsonify({'message': 'Order item created successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@order_item_bp.route('/orderitems', defaults={'order_id': None, 'product_id': None})
@order_item_bp.route('/orderitems/<int:order_id>/<int:product_id>', methods=['GET'])
def get_order_items(order_id, product_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor(dictionary=True)
        if order_id is not None and product_id is not None:
            cursor.execute("""
                SELECT oi.OrderID, oi.ProductID, oi.Quantity, oi.Subtotal,
                       o.OrderDate, o.TotalAmount AS OrderTotal,
                       p.Name AS ProductName, p.Price AS ProductPrice
                FROM OrderItem oi
                JOIN `Order` o ON oi.OrderID = o.OrderID
                JOIN Product p ON oi.ProductID = p.ProductID
                WHERE oi.OrderID = %s AND oi.ProductID = %s""",
                (order_id, product_id))
            order_item = cursor.fetchone()
            if order_item:
                return jsonify(order_item)
            else:
                return jsonify({'message': 'Order item not found'}), 404
        else:
            cursor.execute("""
                SELECT oi.OrderID, oi.ProductID, oi.Quantity, oi.Subtotal,
                       o.OrderDate, o.TotalAmount AS OrderTotal,
                       p.Name AS ProductName, p.Price AS ProductPrice
                FROM OrderItem oi
                JOIN `Order` o ON oi.OrderID = o.OrderID
                JOIN Product p ON oi.ProductID = p.ProductID""")
            order_items = cursor.fetchall()
            return jsonify(order_items)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@order_item_bp.route('/orderitems/<int:order_id>/<int:product_id>', methods=['PUT'])
def update_order_item(order_id, product_id):
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("""
            UPDATE OrderItem 
            SET Quantity=%s, Subtotal=%s 
            WHERE OrderID=%s AND ProductID=%s""",
            (data['Quantity'], data['Subtotal'], order_id, product_id))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No order item found to update'}), 404
        conn.commit()
        return jsonify({'message': 'Order item updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@order_item_bp.route('/orderitems/<int:order_id>/<int:product_id>', methods=['DELETE'])
def delete_order_item(order_id, product_id):
    try :
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("DELETE FROM OrderItem WHERE OrderID=%s AND ProductID=%s", (order_id, product_id))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No order item found to delete'}), 404
        conn.commit()
        return jsonify({'message': 'Order item deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()
