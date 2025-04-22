from flask import Blueprint, jsonify, request, session
from flask_cors import CORS
from models.models import User, Product, Cart
import bcrypt
from connections import get_db
client_bp = Blueprint('client', __name__)
CORS(client_bp)


# Endpoint para registrar un usuario
@client_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')

    # Validación de campos requeridos
    if not all([username, email, password]):
        return jsonify({'success': False, 'message': 'Faltan campos requeridos.'}), 400

    # Validación de longitud de contraseña
    if len(password) < 8:
        return jsonify({'success': False, 'message': 'La contraseña debe tener al menos 8 caracteres.'}), 400

    # Verificar si el correo ya está registrado
    if User.find_by_email(email):
        return jsonify({'success': False, 'message': 'Este correo ya está registrado.'}), 409

    # Intentar crear el usuario
    if User.create(username, email, password):
        return jsonify({'success': True, 'message': 'Registro exitoso.'}), 201
    else:
        return jsonify({'success': False, 'message': 'Error en el registro.'}), 500

# Endpoint para iniciar sesión
@client_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not all([email, password]):
        return jsonify({'success': False, 'message': 'Correo y contraseña son requeridos.'}), 400

    try:
        with get_db() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM users WHERE email = %s", (email,))
                user = cur.fetchone()
                if user and bcrypt.checkpw(password.encode(), user[3].encode()):  # Acceso por índice
                    session['user_id'] = user[0]
                    session['username'] = user[1]
                    return jsonify({
                        'success': True,
                        'message': 'Inicio de sesión exitoso.',
                        'user': {
                            'id': user[0],
                            'username': user[1],
                            'email': user[2]
                        }
                    }), 200
                return jsonify({'success': False, 'message': 'Correo o contraseña incorrectos.'}), 401
    except Exception as e:
        return jsonify({'success': False, 'message': 'Error en inicio de sesión: ' + str(e)}), 500

# Endpoint para obtener todos los productos
@client_bp.route('/api/products', methods=['GET'])
def get_products():
    try:
        with get_db() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM products")
                rows = cur.fetchall()

                # Convertir los resultados en una lista de diccionarios
                products = []
                for row in rows:
                    product = {
                        'id': row[0],
                        'name': row[1],
                        'price': row[2],
                        'description': row[3],
                        'image_url': row[4],
                    }
                    products.append(product)

                return jsonify({'success': True, 'products': products}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error al obtener los productos: {str(e)}'}), 500


# Endpoint para agregar un producto al carrito
@client_bp.route('/api/cart/add/<int:product_id>', methods=['POST'])
def add_to_cart(product_id):
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'success': False, 'message': 'Debes iniciar sesión para agregar productos.'}), 401

    try:
        if Cart.add_product(user_id, product_id):
            return jsonify({'success': True, 'message': 'Producto agregado al carrito.'}), 200
        else:
            return jsonify({'success': False, 'message': 'Error al agregar producto.'}), 500
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error al agregar producto al carrito: {str(e)}'
        }), 500