from flask import Flask
from flask_cors import CORS
from admin import admin_bp
from app.routes import client_bp

app = Flask(__name__)
CORS(app, resources={
    r"/*": {
        "origins": ["*"],  # Specify Angular development server
        "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],  # Include OPTIONS
        "allow_headers": ["Content-Type", "Authorization"],
        "supports_credentials": True
    }
})

app.secret_key = 'secret_key'

# Registrar blueprints
app.register_blueprint(client_bp, url_prefix="/api/client")
app.register_blueprint(admin_bp, url_prefix="/api/admin")

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)

@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', 'http://localhost:4200')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    response.headers.add('Access-Control-Allow-Credentials', 'true')
    return response