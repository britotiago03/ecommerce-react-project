from flask import Blueprint, jsonify, request
from .database import db_connection  

payment_bp = Blueprint('payment', __name__)

@payment_bp.route('/payments', methods=['POST'])
def create_payment():
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO Payment (OrderID, PaymentMethod, Amount, PaymentDate, PaymentStatusID, TransactionID)
            VALUES (%s, %s, %s, %s, %s, %s)""",
            (data['OrderID'], data['PaymentMethod'], data['Amount'], data['PaymentDate'], data['PaymentStatusID'], data['TransactionID']))
        conn.commit()
        return jsonify({'message': 'Payment created successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@payment_bp.route('/payments', defaults={'payment_id': None})
@payment_bp.route('/payments/<int:payment_id>', methods=['GET'])
def get_payments(payment_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor(dictionary=True)
        if payment_id is not None:
            cursor.execute("""
                SELECT p.*, o.TotalAmount AS OrderTotal, ps.StatusName AS PaymentStatus
                FROM Payment p
                JOIN `Order` o ON p.OrderID = o.OrderID
                JOIN PaymentStatus ps ON p.PaymentStatusID = ps.PaymentStatusID
                WHERE p.PaymentID = %s""",
                (payment_id,))
            payment = cursor.fetchone()
            if payment:
                return jsonify(payment)
            else:
                return jsonify({'message': 'Payment not found'}), 404
        else:
            cursor.execute("""
                SELECT p.*, o.TotalAmount AS OrderTotal, ps.StatusName AS PaymentStatus
                FROM Payment p
                JOIN `Order` o ON p.OrderID = o.OrderID
                JOIN PaymentStatus ps ON p.PaymentStatusID = ps.PaymentStatusID""")
            payments = cursor.fetchall()
            return jsonify(payments)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@payment_bp.route('/payments/<int:payment_id>', methods=['PUT'])
def update_payment(payment_id):
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("""
            UPDATE Payment 
            SET OrderID=%s, PaymentMethod=%s, Amount=%s, PaymentDate=%s, PaymentStatusID=%s, TransactionID=%s
            WHERE PaymentID=%s""",
            (data['OrderID'], data['PaymentMethod'], data['Amount'], data['PaymentDate'], data['PaymentStatusID'], data['TransactionID'], payment_id))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No payment found to update'}), 404
        conn.commit()
        return jsonify({'message': 'Payment updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@payment_bp.route('/payments/<int:payment_id>', methods=['DELETE'])
def delete_payment(payment_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Payment WHERE PaymentID=%s", (payment_id,))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No payment found to delete'}), 404
        conn.commit()
        return jsonify({'message': 'Payment deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()
