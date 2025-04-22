from flask import Blueprint, jsonify, request
from flask_cors import CORS
from connections import db_fetchone, get_db
import bcrypt
from config import SECRET_KEY
import jwt  # Importa la biblioteca JWT
from datetime import datetime, timedelta 
from middleware import authenticate_admin_token

admin_bp = Blueprint('admin', __name__)
CORS(admin_bp, resources={r"/*": {"origins": "*"}})

# Endpoint para iniciar sesión como administrador
@admin_bp.route('/login', methods=['POST'])
def admin_login():
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

                if not user:
                    return jsonify({'success': False, 'message': 'Usuario no encontrado.'}), 401

                # Verificar si el usuario es administrador
                if user[4] != 'admin':
                    return jsonify({'success': False, 'message': 'No eres un administrador.'}), 401

                # Verificar la contraseña
                stored_hash = user[3]  # Suponiendo que el hash está en la columna 3
                if not bcrypt.checkpw(password.encode(), stored_hash.encode()):
                    return jsonify({'success': False, 'message': 'Contraseña incorrecta.'}), 401

                # Generar un token JWT
                payload = {
                    'user_id': user[0],  # ID del usuario
                    'exp': datetime.utcnow() + timedelta(hours=24)  # Token válido por 24 horas
                }
                token = jwt.encode(payload, SECRET_KEY, algorithm='HS256')

                # Actualizar el token en la base de datos
                cur.execute("UPDATE users SET token = %s WHERE id = %s", (token, user[0]))
                conn.commit()

                # Devolver la respuesta con el token
                return jsonify({
                    'success': True,
                    'message': 'Inicio de sesión exitoso como administrador.',
                    'user': {
                        'id': user[0],
                        'username': user[1],
                        'email': user[2],
                        'role': user[4]
                    },
                    'token': token  # Devuelve el token generado
                }), 200

    except Exception as e:
        return jsonify({'success': False, 'message': f'Error en inicio de sesión: {str(e)}'}), 500

# Ruta para el dashboard (estadísticas generales)
@admin_bp.route('/dashboard', methods=['GET'])
@authenticate_admin_token  # Protege la ruta con el middleware
def dashboard(user_id):
    try:
        conn = get_db()
        cur = conn.cursor()

        # Contar productos
        cur.execute("SELECT COUNT(*) AS total_products FROM products")
        total_products = cur.fetchone()[0]

        # Contar usuarios
        cur.execute("SELECT COUNT(*) AS total_users FROM users WHERE role='client'")
        total_users = cur.fetchone()[0]

        # Contar órdenes
        cur.execute("SELECT COUNT(*) AS total_orders FROM orders")
        total_orders = cur.fetchone()[0]

        conn.close()

        # Devolver estadísticas en formato JSON
        return jsonify({
            "success": True,
            "data": {
                "total_products": total_products,
                "total_users": total_users,
                "total_orders": total_orders
            }
        }), 200

    except Exception as e:
        return jsonify({
            "success": False,
            "message": f"Error al cargar el dashboard: {str(e)}"
        }), 500

# Ruta para listar productos
@admin_bp.route('/products', methods=['GET'])
@authenticate_admin_token  # Protege la ruta con el middleware
def products(user_id):
    try:
        conn = get_db()
        cur = conn.cursor()
        cur.execute("SELECT * FROM products")
        rows = cur.fetchall()

        # Convertir los datos en un formato serializable
        products = [
            {
                "id": row[0],
                "name": row[1],
                "description": row[2],
                "price": float(row[3]),
                "stock": row[4],
                "image_url": row[5]
            }
            for row in rows
        ]

        conn.close()

        return jsonify({
            "success": True,
            "data": products
        }), 200

    except Exception as e:
        return jsonify({
            "success": False,
            "message": f"Error al obtener los productos: {str(e)}"
        }), 500

# Ruta para agregar un producto
@admin_bp.route('/products/add', methods=['POST'])
@authenticate_admin_token  # Protege la ruta con el middleware
def add_product(user_id):
    data = request.get_json()
    name = data.get('name')
    description = data.get('description')
    price = data.get('price')
    stock = data.get('stock')
    image_url = data.get('image_url')

    if not all([name, description, price, stock, image_url]):
        return jsonify({
            "success": False,
            "message": "Todos los campos son requeridos."
        }), 400

    try:
        price = float(price)
        stock = int(stock)
    except ValueError:
        return jsonify({
            "success": False,
            "message": "El precio y el stock deben ser números válidos."
        }), 400

    try:
        # Consultar el valor máximo actual de id
        query_max_id = "SELECT MAX(id) FROM products"
        max_id = db_fetchone(query_max_id)[0] or 0  # Si no hay registros, usar 0
        new_id = max_id + 1  # Calcular el nuevo id

        # Insertar el nuevo producto con el id generado manualmente
        query = """
            INSERT INTO products (id, name, description, price, stock, image_url)
            VALUES (%s, %s, %s, %s, %s, %s)
        """
        params = (new_id, name, description, price, stock, image_url)

        # Usar un administrador de contexto para manejar la conexión
        with get_db() as conn:
            with conn.cursor() as cur:
                cur.execute(query, params)
                conn.commit()

        return jsonify({
            "success": True,
            "message": "Producto agregado con éxito."
        }), 201

    except Exception as e:
        return jsonify({
            "success": False,
            "message": f"Error al agregar el producto: {str(e)}"
        }), 500

# Ruta para editar un producto
@admin_bp.route('/products/edit/<int:id>', methods=['PUT'])
@authenticate_admin_token  # Protege la ruta con el middleware
def edit_product(user_id, id):
    data = request.get_json()
    name = data.get('name')
    description = data.get('description')
    price = data.get('price')
    stock = data.get('stock')
    image_url = data.get('image_url')

    # Validar que todos los campos estén presentes
    if not all([name, description, price, stock, image_url]):
        return jsonify({
            "success": False,
            "message": "Todos los campos son requeridos."
        }), 400

    try:
        # Validar que el precio y el stock sean números válidos
        price = float(price)
        stock = int(stock)
    except ValueError:
        return jsonify({
            "success": False,
            "message": "El precio y el stock deben ser números válidos."
        }), 400

    try:
        # Usar un administrador de contexto para manejar la conexión
        with get_db() as conn:
            with conn.cursor() as cur:
                # Ejecutar la consulta UPDATE
                query = """
                    UPDATE products 
                    SET name=%s, description=%s, price=%s, stock=%s, image_url=%s 
                    WHERE id=%s
                """
                cur.execute(query, (name, description, price, stock, image_url, id))
                
                # Verificar si se actualizó algún registro
                if cur.rowcount == 0:
                    return jsonify({
                        "success": False,
                        "message": f"No se encontró ningún producto con el ID {id}."
                    }), 404
                
                conn.commit()

        return jsonify({
            "success": True,
            "message": "Producto actualizado con éxito."
        }), 200

    except Exception as e:
        return jsonify({
            "success": False,
            "message": f"Error al actualizar el producto: {str(e)}"
        }), 500

# Ruta para eliminar un producto
@admin_bp.route('/products/delete/<int:id>', methods=['DELETE'])
@authenticate_admin_token  # Protege la ruta con el middleware
def delete_product(user_id, id):
    try:
        # Usar un administrador de contexto para manejar la conexión
        with get_db() as conn:
            with conn.cursor() as cur:
                # Ejecutar la consulta DELETE
                query = "DELETE FROM products WHERE id=%s"
                cur.execute(query, (id,))
                
                # Verificar si se eliminó algún registro
                if cur.rowcount == 0:
                    return jsonify({
                        "success": False,
                        "message": f"No se encontró ningún producto con el ID {id}."
                    }), 404
                
                conn.commit()

        return jsonify({
            "success": True,
            "message": "Producto eliminado con éxito."
        }), 200

    except Exception as e:
        return jsonify({
            "success": False,
            "message": f"Error al eliminar el producto: {str(e)}"
        }), 500