from flask import Blueprint, jsonify, request
from .database import db_connection  

shipping_detail_bp = Blueprint('shipping_detail', __name__)

@shipping_detail_bp.route('/shippingdetails', methods=['POST'])
def create_shipping_detail():
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO ShippingDetail (
                OrderID, RecipientName, AddressID, ShippingMethod, ShippingCost, 
                ExpectedDeliveryDate, TrackingNumber, IsDelivered, DeliveryDate, 
                BaseCost, WeightSurcharge
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""",
            (
                data['OrderID'], data['RecipientName'], data['AddressID'], data['ShippingMethod'], data['ShippingCost'],
                data['ExpectedDeliveryDate'], data['TrackingNumber'], data['IsDelivered'], data['DeliveryDate'], 
                data['BaseCost'], data['WeightSurcharge']
            ))
        conn.commit()
        return jsonify({'message': 'Shipping detail created successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@shipping_detail_bp.route('/shippingdetails', defaults={'shipping_id': None})
@shipping_detail_bp.route('/shippingdetails/<int:shipping_id>', methods=['GET'])
def get_shipping_details(shipping_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor(dictionary=True)
        if shipping_id is not None:
            cursor.execute("""
                SELECT sd.*, o.TotalAmount AS OrderTotalAmount, o.OrderDate,
                       a.Street, a.City, a.State, a.PostalCode, a.Country
                FROM ShippingDetail sd
                JOIN `Order` o ON sd.OrderID = o.OrderID
                JOIN Address a ON sd.AddressID = a.AddressID
                WHERE sd.ShippingID = %s""", (shipping_id,))
            shipping_detail = cursor.fetchone()
            if shipping_detail:
                return jsonify(shipping_detail)
            else:
                return jsonify({'message': 'Shipping detail not found'}), 404
        else:
            cursor.execute("""
                SELECT sd.*, o.TotalAmount AS OrderTotalAmount, o.OrderDate,
                       a.Street, a.City, a.State, a.PostalCode, a.Country
                FROM ShippingDetail sd
                JOIN `Order` o ON sd.OrderID = o.OrderID
                JOIN Address a ON sd.AddressID = a.AddressID""")
            shipping_details = cursor.fetchall()
            return jsonify(shipping_details)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@shipping_detail_bp.route('/shippingdetails/<int:shipping_id>', methods=['PUT'])
def update_shipping_detail(shipping_id):
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("""
            UPDATE ShippingDetail 
            SET OrderID=%s, RecipientName=%s, AddressID=%s, ShippingMethod=%s, ShippingCost=%s, 
                ExpectedDeliveryDate=%s, TrackingNumber=%s, IsDelivered=%s, DeliveryDate=%s, 
                BaseCost=%s, WeightSurcharge=%s 
            WHERE ShippingID=%s""",
            (
                data['OrderID'], data['RecipientName'], data['AddressID'], data['ShippingMethod'], data['ShippingCost'],
                data['ExpectedDeliveryDate'], data['TrackingNumber'], data['IsDelivered'], data['DeliveryDate'], 
                data['BaseCost'], data['WeightSurcharge'], shipping_id
            ))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No shipping detail found to update'}), 404
        conn.commit()
        return jsonify({'message': 'Shipping detail updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@shipping_detail_bp.route('/shippingdetails/<int:shipping_id>', methods=['DELETE'])
def delete_shipping_detail(shipping_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("DELETE FROM ShippingDetail WHERE ShippingID=%s", (shipping_id,))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No shipping detail found to delete'}), 404
        conn.commit()
        return jsonify({'message': 'Shipping detail deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()
