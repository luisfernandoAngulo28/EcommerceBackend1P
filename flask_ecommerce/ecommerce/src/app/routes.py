from flask import Blueprint, jsonify, request, session
from flask_cors import CORS
from models.models import User, Cart 
import bcrypt
from connections import get_db
from config import SECRET_KEY
import jwt 
from datetime import datetime, timedelta
#from ..connections import get_db
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
                # Buscar al usuario por correo electrónico
                cur.execute("SELECT * FROM users WHERE email = %s", (email,))
                user = cur.fetchone()

                if not user or not bcrypt.checkpw(password.encode(), user[3].encode()):  # Verificar contraseña
                    return jsonify({'success': False, 'message': 'Correo o contraseña incorrectos.'}), 401

                # Generar un token JWT
                payload = {
                    'user_id': user[0],  # ID del usuario
                    'exp': datetime.utcnow() + timedelta(hours=24)  # Token válido por 24 horas
                }
                token = jwt.encode(payload, SECRET_KEY, algorithm='HS256')

                # Actualizar el token en la base de datos
                cur.execute("UPDATE users SET token = %s WHERE id = %s", (token, user[0]))
                conn.commit()

                # Guardar el user_id en la sesión
                session['user_id'] = user[0]
                session['username'] = user[1]

                # Devolver la respuesta con el token
                return jsonify({
                    'success': True,
                    'message': 'Inicio de sesión exitoso.',
                    'user': {
                        'id': user[0],
                        'username': user[1],
                        'email': user[2]
                    },
                    'token':  token  # Devuelve el token generado
                }), 200

    except Exception as e:
        return jsonify({'success': False, 'message': f'Error en inicio de sesión: {str(e)}'}), 500    
# Endpoint para obtener todos los productos
@client_bp.route('/products', methods=['GET'])
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
                        'name': row[1],  # Nombre del producto
                        'price': float(row[4]),  # Precio
                        'description': row[3],  # Descripción
                        'image_url': row[5],  # URL de la imagen
                    }
                    products.append(product)

                return jsonify({'success': True, 'products': products}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error al obtener los productos: {str(e)}'}), 500


# Endpoint para agregar un producto al carrito
@client_bp.route('/cart/add/<int:product_id>', methods=['POST'])
def add_to_cart(product_id):
    # Verificar si el usuario está autenticado
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'success': False, 'message': 'Debes iniciar sesión para agregar productos.'}), 401

    try:
        # Verificar si el producto existe
        with get_db() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM products WHERE id = %s", (product_id,))
                product = cur.fetchone()
                if not product:
                    return jsonify({'success': False, 'message': 'Producto no encontrado.'}), 404

        # Agregar el producto al carrito
        with get_db() as conn:
            with conn.cursor() as cur:
                # Verificar si el producto ya está en el carrito
                cur.execute("""
                    SELECT quantity FROM cart WHERE user_id = %s AND product_id = %s
                """, (user_id, product_id))
                existing_item = cur.fetchone()

                if existing_item:
                    # Incrementar la cantidad si el producto ya está en el carrito
                    new_quantity = existing_item[0] + 1
                    cur.execute("""
                        UPDATE cart SET quantity = %s WHERE user_id = %s AND product_id = %s
                    """, (new_quantity, user_id, product_id))
                else:
                    # Agregar el producto al carrito con cantidad inicial de 1
                    cur.execute("""
                        INSERT INTO cart (user_id, product_id, quantity)
                        VALUES (%s, %s, 1)
                    """, (user_id, product_id))

                conn.commit()

        return jsonify({'success': True, 'message': 'Producto agregado al carrito.'}), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error al agregar producto al carrito: {str(e)}'
        }), 500