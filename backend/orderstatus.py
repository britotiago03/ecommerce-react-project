from flask import Blueprint, jsonify, request
from .database import db_connection  

order_status_bp = Blueprint('order_status', __name__)

@order_status_bp.route('/orderstatus', methods=['POST'])
def create_order_status():
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO OrderStatus (StatusName, Description)
            VALUES (%s, %s)""",
            (data['StatusName'], data['Description']))
        conn.commit()
        return jsonify({'message': 'Order Status created successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@order_status_bp.route('/orderstatus', defaults={'orderstatus_id': None})
@order_status_bp.route('/orderstatus/<int:orderstatus_id>', methods=['GET'])
def get_order_statuses(orderstatus_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor(dictionary=True)
        if orderstatus_id is not None:
            cursor.execute("SELECT * FROM OrderStatus WHERE OrderStatusID = %s", (orderstatus_id,))
            status = cursor.fetchone()
            if status:
                return jsonify(status)
            else:
                return jsonify({'message': 'Order Status not found'}), 404
        else:
            cursor.execute("SELECT * FROM OrderStatus")
            statuses = cursor.fetchall()
            return jsonify(statuses)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@order_status_bp.route('/orderstatus/<int:orderstatus_id>', methods=['PUT'])
def update_order_status(orderstatus_id):
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("""
            UPDATE OrderStatus SET StatusName=%s, Description=%s, UpdatedAt=NOW()
            WHERE OrderStatusID=%s""",
            (data['StatusName'], data['Description'], orderstatus_id))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No order status found to update'}), 404
        conn.commit()
        return jsonify({'message': 'Order Status updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@order_status_bp.route('/orderstatus/<int:orderstatus_id>', methods=['DELETE'])
def delete_order_status(orderstatus_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("DELETE FROM OrderStatus WHERE OrderStatusID=%s", (orderstatus_id,))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No order status found to delete'}), 404
        conn.commit()
        return jsonify({'message': 'Order Status deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()
