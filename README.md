# EcommerceBackend1P - Documentación de API

## Estructura del Proyecto

```
EcommerceBackend1P/
├── controllers/
│   ├── authController.js
│   ├── categoriesController.js
│   ├── ordersController.js
│   ├── productsController.js
│   └── usersController.js
├── middleware/
│   ├── authJwt.js
│   ├── index.js
│   └── verifySignUp.js
├── models/
│   ├── categoriesModel.js
│   ├── index.js
│   ├── ordersModel.js
│   ├── productsModel.js
│   ├── roleModel.js
│   └── userModel.js
├── routes/
│   ├── authRoutes.js
│   ├── categoriesRoutes.js
│   ├── ordersRoutes.js
│   ├── productsRoutes.js
│   └── usersRoutes.js
├── config/
│   ├── auth.config.js
│   └── db.config.js
├── server.js
└── package.json
```

## Endpoints Disponibles

### Autenticación

#### POST `/api/auth/signup`
Registra un nuevo usuario en el sistema.

**Request Body:**
```json
{
  "username": "usuario123",
  "email": "usuario@ejemplo.com",
  "password": "contraseña123",
  "roles": ["user", "admin"] // Opcional, por defecto es "user"
}
```

**Response:**
```json
{
  "message": "Usuario registrado correctamente!"
}
```

#### POST `/api/auth/signin`
Inicia sesión y devuelve un token JWT.

**Request Body:**
```json
{
  "username": "usuario123",
  "password": "contraseña123"
}
```

**Response:**
```json
{
  "id": "60d21b4667d0d8992e610c85",
  "username": "usuario123",
  "email": "usuario@ejemplo.com",
  "roles": ["ROLE_USER"],
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Usuarios

#### GET `/api/users`
Obtiene la lista de todos los usuarios (requiere rol de administrador).

**Headers:**
```
x-access-token: [token JWT]
```

**Response:**
```json
[
  {
    "id": "60d21b4667d0d8992e610c85",
    "username": "usuario123",
    "email": "usuario@ejemplo.com",
    "roles": ["60d21b4667d0d8992e610c86"]
  },
  ...
]
```

#### GET `/api/users/:id`
Obtiene información de un usuario específico.

**Headers:**
```
x-access-token: [token JWT]
```

**Response:**
```json
{
  "id": "60d21b4667d0d8992e610c85",
  "username": "usuario123",
  "email": "usuario@ejemplo.com",
  "roles": ["60d21b4667d0d8992e610c86"]
}
```

#### PUT `/api/users/:id`
Actualiza información de un usuario (solo admins o el propio usuario).

**Headers:**
```
x-access-token: [token JWT]
```

**Request Body:**
```json
{
  "username": "nuevousuario",
  "email": "nuevo@ejemplo.com",
  "password": "nuevacontraseña"
}
```

**Response:**
```json
{
  "message": "Usuario actualizado correctamente"
}
```

#### DELETE `/api/users/:id`
Elimina un usuario (solo administradores).

**Headers:**
```
x-access-token: [token JWT]
```

**Response:**
```json
{
  "message": "Usuario eliminado correctamente"
}
```

### Categorías

#### GET `/api/categories`
Obtiene todas las categorías disponibles.

**Response:**
```json
[
  {
    "id": "60d21b4667d0d8992e610c87",
    "name": "Electrónica",
    "description": "Productos electrónicos"
  },
  ...
]
```

#### GET `/api/categories/:id`
Obtiene una categoría específica.

**Response:**
```json
{
  "id": "60d21b4667d0d8992e610c87",
  "name": "Electrónica",
  "description": "Productos electrónicos"
}
```

#### POST `/api/categories`
Crea una nueva categoría (requiere rol de administrador).

**Headers:**
```
x-access-token: [token JWT]
```

**Request Body:**
```json
{
  "name": "Hogar",
  "description": "Productos para el hogar"
}
```

**Response:**
```json
{
  "id": "60d21b4667d0d8992e610c88",
  "name": "Hogar",
  "description": "Productos para el hogar"
}
```

#### PUT `/api/categories/:id`
Actualiza una categoría existente (requiere rol de administrador).

**Headers:**
```
x-access-token: [token JWT]
```

**Request Body:**
```json
{
  "name": "Hogar y Jardín",
  "description": "Productos para el hogar y jardín"
}
```

**Response:**
```json
{
  "message": "Categoría actualizada correctamente"
}
```

#### DELETE `/api/categories/:id`
Elimina una categoría (requiere rol de administrador).

**Headers:**
```
x-access-token: [token JWT]
```

**Response:**
```json
{
  "message": "Categoría eliminada correctamente"
}
```

### Productos

#### GET `/api/products`
Obtiene todos los productos disponibles.

**Query Parameters:**
- `category`: Filtrar por categoría
- `limit`: Límite de resultados
- `page`: Página de resultados

**Response:**
```json
[
  {
    "id": "60d21b4667d0d8992e610c89",
    "name": "Smartphone XYZ",
    "description": "Último modelo de smartphone",
    "price": 599.99,
    "category": "60d21b4667d0d8992e610c87",
    "stock": 50,
    "imageUrl": "http://example.com/images/smartphone.jpg"
  },
  ...
]
```

#### GET `/api/products/:id`
Obtiene información de un producto específico.

**Response:**
```json
{
  "id": "60d21b4667d0d8992e610c89",
  "name": "Smartphone XYZ",
  "description": "Último modelo de smartphone",
  "price": 599.99,
  "category": {
    "id": "60d21b4667d0d8992e610c87",
    "name": "Electrónica"
  },
  "stock": 50,
  "imageUrl": "http://example.com/images/smartphone.jpg"
}
```

#### POST `/api/products`
Crea un nuevo producto (requiere rol de administrador).

**Headers:**
```
x-access-token: [token JWT]
```

**Request Body:**
```json
{
  "name": "Laptop ABC",
  "description": "Laptop de alta gama",
  "price": 1299.99,
  "category": "60d21b4667d0d8992e610c87",
  "stock": 25,
  "imageUrl": "http://example.com/images/laptop.jpg"
}
```

**Response:**
```json
{
  "id": "60d21b4667d0d8992e610c90",
  "name": "Laptop ABC",
  "description": "Laptop de alta gama",
  "price": 1299.99,
  "category": "60d21b4667d0d8992e610c87",
  "stock": 25,
  "imageUrl": "http://example.com/images/laptop.jpg"
}
```

#### PUT `/api/products/:id`
Actualiza un producto existente (requiere rol de administrador).

**Headers:**
```
x-access-token: [token JWT]
```

**Request Body:**
```json
{
  "name": "Laptop ABC Pro",
  "price": 1499.99,
  "stock": 20
}
```

**Response:**
```json
{
  "message": "Producto actualizado correctamente"
}
```

#### DELETE `/api/products/:id`
Elimina un producto (requiere rol de administrador).

**Headers:**
```
x-access-token: [token JWT]
```

**Response:**
```json
{
  "message": "Producto eliminado correctamente"
}
```

### Órdenes/Pedidos

#### GET `/api/orders`
Obtiene todas las órdenes (administrador) o las órdenes del usuario actual.

**Headers:**
```
x-access-token: [token JWT]
```

**Response:**
```json
[
  {
    "id": "60d21b4667d0d8992e610c91",
    "user": "60d21b4667d0d8992e610c85",
    "products": [
      {
        "product": "60d21b4667d0d8992e610c89",
        "quantity": 1,
        "price": 599.99
      }
    ],
    "totalAmount": 599.99,
    "status": "pending",
    "shippingAddress": "Calle Principal 123",
    "createdAt": "2023-06-20T14:30:00.000Z"
  },
  ...
]
```

#### GET `/api/orders/:id`
Obtiene información de una orden específica.

**Headers:**
```
x-access-token: [token JWT]
```

**Response:**
```json
{
  "id": "60d21b4667d0d8992e610c91",
  "user": {
    "id": "60d21b4667d0d8992e610c85",
    "username": "usuario123"
  },
  "products": [
    {
      "product": {
        "id": "60d21b4667d0d8992e610c89",
        "name": "Smartphone XYZ",
        "price": 599.99
      },
      "quantity": 1,
      "price": 599.99
    }
  ],
  "totalAmount": 599.99,
  "status": "pending",
  "shippingAddress": "Calle Principal 123",
  "createdAt": "2023-06-20T14:30:00.000Z"
}
```

#### POST `/api/orders`
Crea una nueva orden.

**Headers:**
```
x-access-token: [token JWT]
```

**Request Body:**
```json
{
  "products": [
    {
      "product": "60d21b4667d0d8992e610c89",
      "quantity": 1
    }
  ],
  "shippingAddress": "Calle Principal 123"
}
```

**Response:**
```json
{
  "id": "60d21b4667d0d8992e610c91",
  "user": "60d21b4667d0d8992e610c85",
  "products": [
    {
      "product": "60d21b4667d0d8992e610c89",
      "quantity": 1,
      "price": 599.99
    }
  ],
  "totalAmount": 599.99,
  "status": "pending",
  "shippingAddress": "Calle Principal 123",
  "createdAt": "2023-06-20T14:30:00.000Z"
}
```

#### PUT `/api/orders/:id/status`
Actualiza el estado de una orden (requiere rol de administrador).

**Headers:**
```
x-access-token: [token JWT]
```

**Request Body:**
```json
{
  "status": "completed"
}
```

**Response:**
```json
{
  "message": "Estado de la orden actualizado correctamente"
}
```

## Diagrama de la Base de Datos

```
+---------------+       +---------------+       +---------------+
|     Users     |       |   Products    |       |  Categories   |
+---------------+       +---------------+       +---------------+
| _id           |       | _id           |       | _id           |
| username      |       | name          |       | name          |
| email         |       | description   |       | description   |
| password      |       | price         |       +---------------+
| roles         |       | category      |
+------+--------+       | stock         |
       |                | imageUrl      |
       |                +-------+-------+
       |                        |
       |                        |
+------v--------+       +-------v-------+
|    Roles      |       |    Orders     |
+---------------+       +---------------+
| _id           |       | _id           |
| name          |       | user          |
+---------------+       | products      |
                        | totalAmount   |
                        | status        |
                        | shippingAddress|
                        | createdAt     |
                        +---------------+
```

## Instrucciones de Uso

1. Clona el repositorio: `git clone https://github.com/luisfernandoAngulo28/EcommerceBackend1P.git`
2. Instala las dependencias: `npm install`
3. Configura las variables de entorno (MongoDB URI, JWT Secret, etc.)
4. Inicia el servidor: `npm start`
5. La API estará disponible en `http://localhost:8080/api/`

## Autenticación

Todas las rutas protegidas requieren un token JWT que debe enviarse en el encabezado HTTP `x-access-token`.

## Roles y Permisos

- **ROLE_USER**: Acceso básico (crear órdenes, ver sus propios datos)
- **ROLE_ADMIN**: Acceso completo (gestionar usuarios, productos, categorías y órdenes)
