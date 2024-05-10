from flask import Blueprint, jsonify, request
from .database import db_connection  

tax_bp = Blueprint('tax', __name__)

@tax_bp.route('/taxes', methods=['POST'])
def create_tax():
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Taxes (Description, TaxPercent, ApplicableToCategoryID) VALUES (%s, %s, %s)",
                       (data['Description'], data['TaxPercent'], data['ApplicableToCategoryID']))
        conn.commit()
        return jsonify({'message': 'Tax created successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@tax_bp.route('/taxes', defaults={'tax_id': None})
@tax_bp.route('/taxes/<int:tax_id>', methods=['GET'])
def get_taxes(tax_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor(dictionary=True)
        if tax_id is not None:
            cursor.execute("SELECT t.TaxID, t.Description, t.TaxPercent, t.ApplicableToCategoryID, c.Name AS CategoryName FROM Taxes t JOIN Category c ON t.ApplicableToCategoryID = c.CategoryID WHERE t.TaxID = %s", (tax_id,))
            tax = cursor.fetchone()
            if tax:
                return jsonify(tax)
            else:
                return jsonify({'message': 'Tax not found'}), 404
        else:
            cursor.execute("SELECT t.TaxID, t.Description, t.TaxPercent, t.ApplicableToCategoryID, c.Name AS CategoryName FROM Taxes t JOIN Category c ON t.ApplicableToCategoryID = c.CategoryID")
            taxes = cursor.fetchall()
            return jsonify(taxes)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@tax_bp.route('/taxes/<int:tax_id>', methods=['PUT'])
def update_tax(tax_id):
    data = request.json
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("UPDATE Taxes SET Description = %s, TaxPercent = %s, ApplicableToCategoryID = %s WHERE TaxID = %s",
                       (data['Description'], data['TaxPercent'], data['ApplicableToCategoryID'], tax_id))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No tax found to update'}), 404
        conn.commit()
        return jsonify({'message': 'Tax updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@tax_bp.route('/taxes/<int:tax_id>', methods=['DELETE'])
def delete_tax(tax_id):
    try:
        conn = db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Taxes WHERE TaxID = %s", (tax_id,))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No tax found to delete'}), 404
        conn.commit()
        return jsonify({'message': 'Tax deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()
