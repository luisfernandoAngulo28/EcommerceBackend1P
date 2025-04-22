from functools import wraps
from flask import request, jsonify
import jwt
from config import SECRET_KEY


def authenticate_admin_token(f):
    @wraps(f)  # Preserva el nombre de la función original
    def wrapper(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({'success': False, 'message': 'Token de autorización faltante.'}), 401

        try:
            # Extraer el token sin el prefijo "Bearer "
            token = token.split(' ')[1]
            payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])

            # Verificar que el usuario sea un administrador
            user_id = payload['user_id']
            return f(user_id, *args, **kwargs)
        except jwt.ExpiredSignatureError:
            return jsonify({'success': False, 'message': 'Token expirado.'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'success': False, 'message': 'Token inválido.'}), 401

    return wrapper