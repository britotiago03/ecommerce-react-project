from flask import Blueprint, jsonify, request
import hashlib
from .database import db_connection  

user_bp = Blueprint('user', __name__)

@user_bp.route('/users', methods=['POST'])
def register_user():
    data = request.json
    hashed_password = hashlib.sha256(data['Password'].encode()).hexdigest()  # Hashing the password
    try:
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO User (Username, Password, Email, FirstName, LastName, ProfilePicURL, DateOfBirth)
            VALUES (%s, %s, %s, %s, %s, %s, %s)""",
            (data['Username'], hashed_password, data['Email'], data['FirstName'], data['LastName'], data['ProfilePicURL'], data['DateOfBirth']))
        conn.commit()
        return jsonify({'message': 'User registered successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@user_bp.route('/users', defaults={'user_id': None})
@user_bp.route('/users/<int:user_id>', methods=['GET'])
def get_users(user_id):
    try:
        conn = db_connection()
        cursor = conn.cursor(dictionary=True)
        if user_id is not None:
            cursor.execute("SELECT UserID, Username, Email, FirstName, LastName, ProfilePicURL, DateOfBirth, LastLogin FROM User WHERE UserID = %s", (user_id,))
            user = cursor.fetchone()
            if user:
                return jsonify(user)
            else:
                return jsonify({'message': 'User not found'}), 404
        else:
            cursor.execute("SELECT UserID, Username, Email, FirstName, LastName, ProfilePicURL, DateOfBirth, LastLogin FROM User")
            users = cursor.fetchall()
            return jsonify(users)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@user_bp.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    data = request.json
    hashed_password = hashlib.sha256(data['Password'].encode()).hexdigest() if 'Password' in data else None
    try:
        conn = db_connection()
        cursor = conn.cursor()
        update_query = """
            UPDATE User SET Username = %s, {} Email = %s, FirstName = %s, LastName = %s, ProfilePicURL = %s, DateOfBirth = %s
            WHERE UserID = %s""".format("Password = %s," if hashed_password else "")
        update_values = (
            [data['Username'], data['Email'], data['FirstName'], data['LastName'], data['ProfilePicURL'], data['DateOfBirth'], user_id] if not hashed_password else
            [data['Username'], hashed_password, data['Email'], data['FirstName'], data['LastName'], data['ProfilePicURL'], data['DateOfBirth'], user_id]
        )
        cursor.execute(update_query, update_values)
        if cursor.rowcount == 0:
            return jsonify({'message': 'No user found to update'}), 404
        conn.commit()
        return jsonify({'message': 'User updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@user_bp.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    try:
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM User WHERE UserID = %s", (user_id,))
        if cursor.rowcount == 0:
            return jsonify({'message': 'No user found to delete'}), 404
        conn.commit()
        return jsonify({'message': 'User deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()
