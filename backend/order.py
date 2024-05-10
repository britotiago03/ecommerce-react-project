from flask import Blueprint, jsonify, request
from .database import db_connection  

order_bp = Blueprint('order', __name__)

@order_bp.route('/orders', methods=['POST'])
def create_order():
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO `Order` (UserID, OrderDate, TotalAmount, OrderStatusID, PaymentConfirmedDate)
            VALUES (%s, %s, %s, %s, %s)""",
            (data['UserID'], data['OrderDate'], data['TotalAmount'], data['OrderStatusID'], data['PaymentConfirmedDate']))
        conn.commit()
        return jsonify({'message': 'Order created successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@order_bp.route('/orders', defaults={'order_id': None})
@order_bp.route('/orders/<int:order_id>', methods=['GET'])
def get_orders(order_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor(dictionary=True)
        if order_id is not None:
            cursor.execute("""
                SELECT o.OrderID, o.UserID, o.OrderDate, o.TotalAmount, o.OrderStatusID, o.PaymentConfirmedDate,
                u.Username AS UserName, os.StatusName AS OrderStatus
                FROM `Order` o
                JOIN User u ON o.UserID = u.UserID
                JOIN OrderStatus os ON o.OrderStatusID = os.OrderStatusID
                WHERE o.OrderID = %s""", (order_id,))
            order = cursor.fetchone()
            if order:
                return jsonify(order)
            else:
                return jsonify({'message': 'Order not found'}), 404
        else:
            cursor.execute("""
                SELECT o.OrderID, o.UserID, o.OrderDate, o.TotalAmount, o.OrderStatusID, o.PaymentConfirmedDate,
                u.Username AS UserName, os.StatusName AS OrderStatus
                FROM `Order` o
                JOIN User u ON o.UserID = u.UserID
                JOIN OrderStatus os ON o.OrderStatusID = os.OrderStatusID""")
            orders = cursor.fetchall()
            return jsonify(orders)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@order_bp.route('/orders/<int:order_id>', methods=['PUT'])
def update_order(order_id):
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("""
            UPDATE `Order`
            SET UserID=%s, OrderDate=%s, TotalAmount=%s, OrderStatusID=%s, PaymentConfirmedDate=%s
            WHERE OrderID=%s""",
            (data['UserID'], data['OrderDate'], data['TotalAmount'], data['OrderStatusID'], data['PaymentConfirmedDate'], order_id))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No order found to update'}), 404
        conn.commit()
        return jsonify({'message': 'Order updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@order_bp.route('/orders/<int:order_id>', methods=['DELETE'])
def delete_order(order_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("DELETE FROM `Order` WHERE OrderID=%s", (order_id,))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No order found to delete'}), 404
        conn.commit()
        return jsonify({'message': 'Order deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()
