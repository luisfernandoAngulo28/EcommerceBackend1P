-- Tabla de usuarios
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(10) DEFAULT 'client' CHECK (role IN ('admin', 'client'))
);

-- Tabla de productos
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2),
    stock INT DEFAULT 0,
    image_url VARCHAR(255)
);

-- Tabla de carrito
CREATE TABLE cart (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    product_id INT REFERENCES products(id),
    quantity INT
);

-- Tabla de órdenes
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    total NUMERIC(10, 2),
    status VARCHAR(10) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- poblar base 

INSERT INTO products (id, name, description, price, stock, image_url) VALUES
(1, 'Notebook Galaxy Book 2 Pro', 'Notebook Galaxy Book 2 Pro - 950XEE-XA1, Core i7-1260p, 16 GB RAM, 512 GB SSD, 15.6" - Samsung', 14199.04, 50, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/g/a/galaxy-book-2-pro.jpg'),
(2, 'Tablet Samsung S7FE', 'Tablet Samsung de 12.4 pulgadas, color plata, 4 GB RAM, 64 GB almacenamiento - S7FE', 5439.15, 30, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/s/7/s7fe.jpg'),
(3, 'Auriculares W24', 'Auriculares color azul W24', 199.00, 100, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/w/2/w24.jpg'),
(4, 'Mouse Dell inalámbrico WM126', 'Mouse Dell inalámbrico USB color negro - WM126', 179.00, 100, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/w/m/wm126.jpg'),
(5, 'Notebook Acer Chromebook 315', 'Notebook Acer Chromebook 315, Intel Celeron N4500, 4 GB RAM, 15.6 pulgadas, color púrpura', 2999.00, 50, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/c/h/chromebook-315.jpg'),
(6, 'Tablet Xiaomi Redmi Pad Pro', 'Tablet Xiaomi Redmi Pad Pro, 12 pulgadas, 8 GB RAM, 256 GB almacenamiento, color gris grafito', 4299.00, 30, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/r/e/redmi-pad-pro.jpg'),
(7, 'Tablet Xiaomi Redmi Pad SE', 'Tablet Xiaomi Redmi Pad SE, 8.7 pulgadas, 4 GB RAM, 64 GB almacenamiento, color azul', 1999.00, 40, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/r/e/redmi-pad-se.jpg'),
(8, 'Tablet Xiaomi Pad 6', 'Tablet Xiaomi Pad 6, 11 pulgadas, 6 GB RAM, 128 GB almacenamiento, color gris grafito', 4699.00, 25, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/p/a/pad-6.jpg'),
(9, 'Notebook Lenovo Ideapad 3 15IAU7', 'Notebook Lenovo Ideapad 3 15IAU7', 5399.00, 40, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/i/d/ideapad-3.jpg'),
(10, 'Notebook HP 15_EF2517LA', 'Notebook HP 15_EF2517LA', 5999.00, 35, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/h/p/hp-15_ef2517la.jpg'),
(11, 'Laptop Dell Inspiron 3511', 'Laptop Dell Inspiron 3511, Intel Core i5-1135G7, 8 GB RAM, 256 GB SSD, pantalla 15.6", Windows 11', 6399.00, 25, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/i/n/inspiron-3511.jpg'),
(12, 'Teclado Logitech K380', 'Teclado inalámbrico Logitech K380, multi-dispositivo, color grafito', 289.00, 80, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/k/3/k380.jpg'),
(13, 'Auriculares Logitech G733 Lightspeed', 'Auriculares inalámbricos para gaming Logitech G733 Lightspeed, sonido envolvente, RGB, color negro', 999.00, 35, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/g/7/g733.jpg'),
(14, 'Disco Duro Externo Seagate 1TB', 'Disco duro portátil Seagate Expansion, USB 3.0, 1TB, color negro', 429.00, 60, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/s/e/seagate-1tb.jpg'),
(15, 'Monitor Samsung 24" Curvo', 'Monitor Samsung LED curvo de 24 pulgadas, resolución Full HD, 75 Hz, FreeSync', 999.00, 20, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/m/o/monitor-curvo.jpg'),
(16, 'Mouse Gamer Redragon M612', 'Mouse Redragon M612 Predator RGB, 8000 DPI, 11 botones programables, para gamers', 179.00, 70, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/m/6/m612.jpg'),
(17, 'Base Enfriadora para Laptop KLIM', 'Base enfriadora KLIM Wind, con 4 ventiladores, compatible con laptops de hasta 19 pulgadas', 259.00, 40, 'https://m.media-amazon.com/images/I/71iyv54fzDL._AC_SL1500_.jpg'),
(18, 'Tablet Samsung Galaxy Tab A9+', 'Tablet Samsung Galaxy Tab A9+, 11 pulgadas, 4 GB RAM, 64 GB almacenamiento, color gris', 1999.00, 28, 'https://m.media-amazon.com/images/I/71yzJoE7WnL._AC_SL1500_.jpg'),
(19, 'Router TP-Link Archer AX10', 'Router Wi-Fi 6 TP-Link Archer AX10, velocidad hasta 1.5 Gbps, triple banda', 489.00, 30, 'https://m.media-amazon.com/images/I/61IHoI+l5wL._AC_SL1500_.jpg'),
(20, 'Cable HDMI 4K Ugreen', 'Cable HDMI 2.1 de alta velocidad Ugreen, 2 metros, compatible con 4K/8K, HDR', 89.00, 90, 'https://m.media-amazon.com/images/I/61u3oHz6lML._AC_SL1500_.jpg'),
(21, 'Smart TV Samsung 55" 4K UHD', 'Smart TV Samsung Crystal UHD 55 pulgadas, 4K, HDR, Tizen OS', 2799.00, 18, 'https://m.media-amazon.com/images/I/71rYqgxN-sL._AC_SL1500_.jpg'),
(22, 'Smart TV LG 50" 4K ThinQ AI', 'TV LG 50 pulgadas UHD 4K, ThinQ AI, WebOS, compatible con Alexa y Google', 2599.00, 15, 'https://m.media-amazon.com/images/I/71sYYwY9wBL._AC_SL1500_.jpg'),
(23, 'Laptop HP 245 G9 Ryzen 5', 'Laptop HP 245 G9, procesador AMD Ryzen 5 5625U, 8 GB RAM, SSD 512 GB, 14"', 3390.00, 22, 'https://www.tiendaamiga.com.bo/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/2/4/245-g9.jpg'),
(24, 'Audífonos JBL Tune 510BT', 'Auriculares JBL Tune 510BT inalámbricos con Bluetooth, sonido Pure Bass, batería de 40 horas', 279.00, 55, 'https://m.media-amazon.com/images/I/61j9ZjQ+8lL._AC_SL1500_.jpg'),
(25, 'Mouse Inalámbrico Logitech M170', 'Mouse Logitech M170 inalámbrico con receptor USB, diseño ambidiestro', 79.00, 70, 'https://m.media-amazon.com/images/I/51eP1p3bQFL._AC_SL1000_.jpg'),
(26, 'Tablet Amazon Fire HD 10', 'Tablet Fire HD 10, 10.1 pulgadas, 3 GB RAM, 32 GB almacenamiento, pantalla FHD', 649.00, 33, 'https://m.media-amazon.com/images/I/41p5HjvE4PL._AC_SL1000_.jpg'),
(27, 'Webcam Logitech C920 HD Pro', 'Webcam Logitech C920 HD Pro, Full HD 1080p, micrófono estéreo, para videollamadas', 589.00, 25, 'https://m.media-amazon.com/images/I/61BOd2-KSXL._AC_SL1500_.jpg'),
(28, 'Memoria RAM DDR4 8GB Kingston', 'Módulo de memoria RAM Kingston Fury Beast, DDR4, 8GB, 3200MHz', 249.00, 45, 'https://m.media-amazon.com/images/I/61X+0f5D+tL._AC_SL1000_.jpg'),
(29, 'Disco SSD Kingston 480GB', 'Unidad de estado sólido Kingston A400, 2.5", 480 GB, SATA 3', 319.00, 38, 'https://m.media-amazon.com/images/I/91+aX-Z4DfL._AC_SL1500_.jpg'),
(30, 'Hub USB-C 6 en 1 Ugreen', 'Adaptador Hub Ugreen USB-C 6 en 1 con HDMI, USB 3.0, lector de tarjetas y carga PD', 199.00, 50, 'https://m.media-amazon.com/images/I/61nlBvYZ2IL._AC_SL1500_.jpg'),
(31, 'Impresora Multifuncional Epson L3210', 'Impresora Epson EcoTank L3210, multifuncional 3 en 1, sistema de tinta continua, USB', 999.00, 20, 'https://m.media-amazon.com/images/I/61Apq5Uev1L._AC_SL1500_.jpg'),
(32, 'Impresora HP Smart Tank 580', 'Impresora inalámbrica HP Smart Tank 580, impresión a color, copia, escaneo, Wi-Fi', 1120.00, 15, 'https://m.media-amazon.com/images/I/81z3Wq50e7L._AC_SL1500_.jpg'),
(33, 'Impresora Brother HL-1212W', 'Impresora láser monocromática Brother HL-1212W, compacta, Wi-Fi, 20 ppm', 890.00, 12, 'https://m.media-amazon.com/images/I/81Ku6yd6IVL._AC_SL1500_.jpg'),
(34, 'Impresora Canon G2160', 'Impresora Canon Pixma G2160, multifuncional, sistema de tinta continua, USB, 8.8 ppm', 1075.00, 18, 'https://m.media-amazon.com/images/I/81bf3EjgZlL._AC_SL1500_.jpg'),
(35, 'Impresora Epson EcoTank L1210', 'Impresora Epson L1210, sistema continuo de tinta, impresión a color, USB', 820.00, 25, 'https://m.media-amazon.com/images/I/71nd8mf+CDL._AC_SL1500_.jpg'),
(36, 'Impresora HP DeskJet Ink Advantage 2775', 'Multifuncional HP 2775, impresión, copia, escaneo, Wi-Fi, USB', 590.00, 30, 'https://m.media-amazon.com/images/I/71XG3j4OlUL._AC_SL1500_.jpg'),
(37, 'Impresora Brother DCP-T520W', 'Impresora multifuncional Brother DCP-T520W, tinta continua, Wi-Fi y USB', 1190.00, 14, 'https://m.media-amazon.com/images/I/51Hn+jOpDwL._AC_SL1000_.jpg'),
(38, 'Impresora Canon G3110 Wi-Fi', 'Impresora Canon G3110, multifuncional inalámbrica, tanque de tinta integrado, impresión móvil', 1240.00, 10, 'https://m.media-amazon.com/images/I/81lmq4qKH+L._AC_SL1500_.jpg'),
(39, 'Impresora Epson L3250 Wi-Fi', 'Epson EcoTank L3250, impresión inalámbrica, escaneo y copia, 33 ppm', 1125.00, 16, 'https://m.media-amazon.com/images/I/61iEmXp71rL._AC_SL1500_.jpg'),
(40, 'Impresora HP LaserJet M111w', 'Impresora láser monocromática HP M111w, Wi-Fi, impresión rápida 21 ppm, USB', 790.00, 20, 'https://m.media-amazon.com/images/I/71jZ-s6H3gL._AC_SL1500_.jpg'),
(41, 'Samsung Galaxy A14', 'Samsung Galaxy A14, pantalla de 6.6", 128GB, 4GB RAM, cámara triple de 50MP, color negro', 1020.00, 20, 'https://m.media-amazon.com/images/I/71d7rfSl0wL._AC_SL1500_.jpg'),
(42, 'Xiaomi Redmi Note 12', 'Xiaomi Redmi Note 12, pantalla AMOLED de 6.67", 128GB, 6GB RAM, cámara 50MP', 980.00, 18, 'https://m.media-amazon.com/images/I/71u5lH72JcL._AC_SL1500_.jpg'),
(43, 'Motorola Moto G73 5G', 'Motorola Moto G73, 5G, 256GB de almacenamiento, 8GB de RAM, cámara 50MP, color azul', 1170.00, 12, 'https://m.media-amazon.com/images/I/61W63C6+IlL._AC_SL1500_.jpg'),
(44, 'iPhone 13', 'Apple iPhone 13, 128GB, 6.1", chip A15 Bionic, cámara dual 12MP, color medianoche', 3950.00, 10, 'https://m.media-amazon.com/images/I/61-r9zOKBCL._AC_SL1500_.jpg'),
(45, 'Samsung Galaxy S23 Ultra', 'Samsung Galaxy S23 Ultra, 6.8", 256GB, cámara de 200MP, 12GB RAM, 5G, color phantom black', 6390.00, 8, 'https://m.media-amazon.com/images/I/61VfL-aiToL._AC_SL1500_.jpg'),
(46, 'Realme C55', 'Realme C55, 6.72" FHD+, 128GB, 6GB RAM, cámara de 64MP, batería 5000mAh, carga rápida', 890.00, 25, 'https://m.media-amazon.com/images/I/71nQk1G86QL._AC_SL1500_.jpg'),
(47, 'Poco X5 Pro 5G', 'Xiaomi Poco X5 Pro 5G, Snapdragon 778G, 6GB RAM, 128GB ROM, pantalla AMOLED 6.67"', 1260.00, 14, 'https://m.media-amazon.com/images/I/61L7YFU1EHL._AC_SL1500_.jpg'),
(48, 'Infinix Hot 30', 'Infinix Hot 30, pantalla de 6.78", 128GB, 8GB RAM, cámara de 50MP, batería 5000mAh', 750.00, 22, 'https://m.media-amazon.com/images/I/61XzSme4hFL._AC_SL1500_.jpg'),
(49, 'iPhone SE 2022', 'Apple iPhone SE (3ra Gen), 128GB, chip A15 Bionic, pantalla Retina HD de 4.7", cámara 12MP', 2590.00, 15, 'https://m.media-amazon.com/images/I/61-MT8AQAPL._AC_SL1500_.jpg'),
(50, 'Samsung Galaxy A34 5G', 'Samsung Galaxy A34 5G, pantalla Super AMOLED 6.6", 128GB, 6GB RAM, cámara triple 48MP', 1180.00, 17, 'https://m.media-amazon.com/images/I/71khyUalRZL._AC_SL1500_.jpg'),
(51, 'Sony WH-1000XM5', 'Auriculares Sony WH-1000XM5, cancelación de ruido, Bluetooth, 30 horas de autonomía, color negro', 499.00, 20, 'https://m.media-amazon.com/images/I/81cJf9z0VwL._AC_SL1500_.jpg'),
(52, 'Apple AirPods Pro 2', 'AirPods Pro 2, cancelación activa de ruido, modo transparencia, hasta 6 horas de autonomía, carga inalámbrica', 249.00, 25, 'https://m.media-amazon.com/images/I/71kFfv9lXtL._AC_SL1500_.jpg'),
(53, 'Bose QuietComfort 45', 'Auriculares Bose QuietComfort 45, cancelación activa de ruido, Bluetooth, 24 horas de autonomía, color negro', 329.00, 18, 'https://m.media-amazon.com/images/I/71dH0h2H4yL._AC_SL1500_.jpg'),
(54, 'JBL Tune 125TWS', 'Auriculares JBL Tune 125TWS, Bluetooth, hasta 32 horas de autonomía, sonido JBL Pure Bass, color blanco', 49.00, 30, 'https://m.media-amazon.com/images/I/61-Jbi52h1L._AC_SL1500_.jpg'),
(55, 'Sennheiser Momentum 3', 'Auriculares Sennheiser Momentum 3, cancelación activa de ruido, Bluetooth, 17 horas de autonomía, color negro', 399.00, 15, 'https://m.media-amazon.com/images/I/81BhYYbgz7L._AC_SL1500_.jpg'),
(56, 'Anker Soundcore Life P2', 'Auriculares Anker Soundcore Life P2, sonido de alta calidad, Bluetooth, hasta 40 horas de autonomía', 39.99, 40, 'https://m.media-amazon.com/images/I/61UoGpYWB5L._AC_SL1000_.jpg'),
(57, 'Beats Fit Pro', 'Auriculares Beats Fit Pro, cancelación activa de ruido, resistencia al agua, hasta 24 horas de autonomía', 199.00, 22, 'https://m.media-amazon.com/images/I/71g2T99dDVL._AC_SL1500_.jpg'),
(58, 'Jabra Elite 85h', 'Auriculares Jabra Elite 85h, cancelación activa de ruido, hasta 36 horas de autonomía, Bluetooth, color negro', 249.00, 14, 'https://m.media-amazon.com/images/I/81ddUpvInTL._AC_SL1500_.jpg'),
(59, 'Skullcandy Indy ANC', 'Auriculares Skullcandy Indy ANC, cancelación activa de ruido, Bluetooth, hasta 24 horas de autonomía, color negro', 119.00, 17, 'https://m.media-amazon.com/images/I/81N-iyVnD6L._AC_SL1500_.jpg'),
(60, 'Samsung Galaxy Buds Pro', 'Auriculares Samsung Galaxy Buds Pro, sonido premium, cancelación activa de ruido, hasta 28 horas de autonomía', 199.00, 20, 'https://m.media-amazon.com/images/I/71-Ibpjm0AL._AC_SL1500_.jpg'),
(61, 'Logitech K780 Multi-Device Wireless Keyboard', 'Teclado Logitech K780, inalámbrico, multi-dispositivo, con soporte para tabletas y teléfonos', 49.99, 30, 'https://m.media-amazon.com/images/I/61zQbBxwsvL._AC_SL1500_.jpg'),
(62, 'Razer BlackWidow V3 Mechanical Keyboard', 'Teclado Razer BlackWidow V3, mecánico, retroiluminado, switch verde, ideal para gaming', 109.99, 18, 'https://m.media-amazon.com/images/I/71LVDfCwNGL._AC_SL1500_.jpg'),
(63, 'Apple Magic Keyboard', 'Teclado Apple Magic Keyboard, inalámbrico, para iPad y Mac, diseño delgado y elegante', 129.00, 25, 'https://m.media-amazon.com/images/I/71iTAeOSDOL._AC_SL1500_.jpg'),
(64, 'Microsoft Surface Pro Type Cover', 'Teclado Microsoft Surface Pro Type Cover, para tablet Surface Pro, teclado retroiluminado y táctil', 129.99, 20, 'https://m.media-amazon.com/images/I/71xhHWJQ+6L._AC_SL1500_.jpg'),
(65, 'Samsung Galaxy Tab S7', 'Tableta Samsung Galaxy Tab S7, 11" LCD, Snapdragon 865+, 128GB, 6GB RAM, con S Pen', 649.99, 15, 'https://m.media-amazon.com/images/I/71pdEdz-vwL._AC_SL1500_.jpg'),
(66, 'Lenovo Tab P11', 'Tableta Lenovo Tab P11, 11" 2K, 128GB, 4GB RAM, compatible con teclado y lápiz', 229.99, 25, 'https://m.media-amazon.com/images/I/71+d6jzw99L._AC_SL1500_.jpg'),
(67, 'Logitech K400 Plus Wireless Touch Keyboard', 'Teclado Logitech K400 Plus, inalámbrico, con touchpad, ideal para tabletas y televisores inteligentes', 29.99, 30, 'https://m.media-amazon.com/images/I/71wB5bmdBhL._AC_SL1500_.jpg'),
(68, 'Apple iPad Air 5', 'Tableta Apple iPad Air 5, 10.9" Liquid Retina, M1, 64GB, 5G, compatible con Apple Pencil y teclado', 599.00, 12, 'https://m.media-amazon.com/images/I/81kMdJXtXwL._AC_SL1500_.jpg'),
(69, 'Xiaomi Mi Pad 5', 'Tableta Xiaomi Mi Pad 5, 11" 2K, Snapdragon 860, 128GB, 6GB RAM, compatible con teclado y lápiz', 359.99, 10, 'https://m.media-amazon.com/images/I/71+en3gT2wL._AC_SL1500_.jpg'),
(70, 'Samsung Galaxy Tab A8', 'Tableta Samsung Galaxy Tab A8, 10.5" TFT, 32GB, 3GB RAM, con Android 11, color gris', 229.00, 20, 'https://m.media-amazon.com/images/I/71CqS4C9BzL._AC_SL1500_.jpg'),
(71, 'LG WM4000HWA 4.5 Cu. Ft. Front Load Washer', 'Lavadora frontal LG WM4000HWA, 4.5 cu. ft., tecnología TurboWash, Wi-Fi integrado', 899.00, 15, 'https://m.media-amazon.com/images/I/71OXrK5xx2L._AC_SL1500_.jpg'),
(72, 'Samsung WF45R6100AW Front Load Washer', 'Lavadora Samsung WF45R6100AW, 4.5 cu. ft., tecnología VRT Plus, eficiente en consumo de agua', 749.00, 20, 'https://m.media-amazon.com/images/I/71c9uV66RDL._AC_SL1500_.jpg'),
(73, 'Whirlpool WFW560CHW Front Load Washer', 'Lavadora Whirlpool WFW560CHW, 4.2 cu. ft., carga frontal, tecnología Precision Dispense', 649.00, 18, 'https://m.media-amazon.com/images/I/71fG7VqfUoL._AC_SL1500_.jpg'),
(74, 'Maytag MHW5630HW Front Load Washer', 'Lavadora Maytag MHW5630HW, 5.0 cu. ft., capacidad grande, Steam for Stains, carga frontal', 899.00, 12, 'https://m.media-amazon.com/images/I/61V5vUt9tqL._AC_SL1500_.jpg'),
(75, 'GE GFW450SSMWW Front Load Washer', 'Lavadora GE GFW450SSMWW, 4.5 cu. ft., carga frontal, ciclo SmartDispense, tecnología de vapor', 799.00, 16, 'https://m.media-amazon.com/images/I/71Dd0cDR-AL._AC_SL1500_.jpg'),
(76, 'Electrolux EFLS627UTT Front Load Washer', 'Lavadora Electrolux EFLS627UTT, 4.4 cu. ft., tecnología SmartBoost, carga frontal', 999.00, 14, 'https://m.media-amazon.com/images/I/81Z0Tg0jO3L._AC_SL1500_.jpg'),
(77, 'Bosch 500 Series 4.0 Cu. Ft. Front Load Washer', 'Lavadora Bosch 500 Series, 4.0 cu. ft., EcoSilence Drive, tecnología ActiveWater', 849.00, 19, 'https://m.media-amazon.com/images/I/91gyxgOORjL._AC_SL1500_.jpg'),
(78, 'Frigidaire FFTW4120SW Front Load Washer', 'Lavadora Frigidaire FFTW4120SW, 4.1 cu. ft., carga frontal, ciclo de lavado rápido', 699.00, 25, 'https://m.media-amazon.com/images/I/71Y0Y1OF57L._AC_SL1500_.jpg'),
(79, 'Samsung WA45T3400AZ Top Load Washer', 'Lavadora Samsung WA45T3400AZ, 4.5 cu. ft., carga superior, tecnología ActiveWaterJet', 579.00, 22, 'https://m.media-amazon.com/images/I/61wG9bP0p2L._AC_SL1500_.jpg'),
(80, 'LG WT7300CW Top Load Washer', 'Lavadora LG WT7300CW, 5.0 cu. ft., carga superior, TurboWash3D, Wi-Fi conectado', 899.00, 15, 'https://m.media-amazon.com/images/I/81+kwB0tbRL._AC_SL1500_.jpg');