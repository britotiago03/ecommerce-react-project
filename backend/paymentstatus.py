from flask import Blueprint, jsonify, request
from .database import db_connection

payment_status_bp = Blueprint('payment_status', __name__)

@payment_status_bp.route('/paymentstatuses', methods=['POST'])
def create_payment_status():
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("INSERT INTO PaymentStatus (StatusName) VALUES (%s)", (data['StatusName'],))
        conn.commit()
        return jsonify({'message': 'Payment Status created successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@payment_status_bp.route('/paymentstatuses', defaults={'paymentstatus_id': None})
@payment_status_bp.route('/paymentstatuses/<int:paymentstatus_id>', methods=['GET'])
def get_payment_statuses(paymentstatus_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor(dictionary=True)
        if paymentstatus_id is not None:
            cursor.execute("SELECT * FROM PaymentStatus WHERE PaymentStatusID = %s", (paymentstatus_id,))
            payment_status = cursor.fetchone()
            if payment_status:
                return jsonify(payment_status)
            else:
                return jsonify({'message': 'Payment Status not found'}), 404
        else:
            cursor.execute("SELECT * FROM PaymentStatus")
            payment_statuses = cursor.fetchall()
            return jsonify(payment_statuses)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@payment_status_bp.route('/paymentstatuses/<int:paymentstatus_id>', methods=['PUT'])
def update_payment_status(paymentstatus_id):
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("UPDATE PaymentStatus SET StatusName=%s WHERE PaymentStatusID=%s", (data['StatusName'], paymentstatus_id))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No payment status found to update'}), 404
        conn.commit()
        return jsonify({'message': 'Payment Status updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@payment_status_bp.route('/paymentstatuses/<int:paymentstatus_id>', methods=['DELETE'])
def delete_payment_status(paymentstatus_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("DELETE FROM PaymentStatus WHERE PaymentStatusID=%s", (paymentstatus_id,))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No payment status found to delete'}), 404
        conn.commit()
        return jsonify({'message': 'Payment Status deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()
