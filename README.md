🏢 Sistema de Gestión de Proveedores - Frontend (Connexa)
Este repositorio alberga el cliente oficial del Sistema de Gestión de Proveedores, una solución empresarial diseñada bajo estándares de ingeniería de software de alto rendimiento. La aplicación no solo busca la eficiencia operativa, sino que redefine la experiencia de usuario mediante transformaciones espaciales y una arquitectura desacoplada.

🏗️ Arquitectura: Feature-Driven Clean Architecture
Hoy hemos migrado el proyecto hacia una Arquitectura basada en Características, lo que permite un escalamiento horizontal infinito sin comprometer la legibilidad del código. La lógica se organiza ahora de la siguiente manera:

📁 Organización de la Capa de Aplicación (/lib)
core/: El núcleo del sistema. Contiene los modelos de datos inmutables (Order, Notification, User) y la gestión centralizada de temas y activos multimedia.

features/: Cada módulo es una unidad de negocio independiente.

Auth: Gestión de sesiones y flujos de acceso.

Suppliers: Directorio inteligente y búsqueda de proveedores.

Orders: Historial de transacciones y estados de pedido.

Notifications: Centro de alertas con gestión de gestos.

Profile: Configuración de usuario con componentes expandibles.

shared/: Widgets y componentes transversales (como el Menú Lateral y la Barra de Navegación) que sirven a múltiples características.

🎨 Ingeniería Visual y UX 3D
La interfaz de Connexa utiliza técnicas de renderizado avanzado para ofrecer una profundidad visual superior:

Shell de Navegación 3D: Se ha implementado un sistema de capas donde el contenido principal rota en el eje Y y reduce su escala al abrir el menú lateral, creando una ilusión de profundidad tridimensional mediante matrices de transformación.

Sincronización de Capas: El botón de menú (desarrollado en Rive) está sincronizado con el estado de la animación de Flutter, garantizando que la interactividad táctil y la visual sigan el mismo ritmo.

Efecto Glassmorphism: Aplicación estratégica de desenfoque de imagen en tiempo real para separar visualmente el contenido del fondo dinámico, manteniendo una jerarquía clara.

🛡️ Funcionalidades Implementadas (Estado Actual)
1. Centro de Notificaciones Inteligente
Interacción Táctil: Soporte para el gesto de deslizamiento (Swipe-to-dismiss) para limpiar alertas.

Lógica de Recuperación: Sistema de "Deshacer" (Undo) integrado mediante notificaciones flotantes, permitiendo revertir acciones accidentales.

Lectura Dinámica: Tarjetas de notificación expandibles que permiten leer mensajes largos sin salir de la vista principal.

2. Gestión de Perfil Modular
Componentes Expandibles: Uso de tarjetas inteligentes que agrupan opciones funcionales, optimizando el espacio en pantalla.

Identidad Visual: Integración de avatares 3D vectoriales para una representación profesional del usuario.

3. Navegación Sincronizada
El Menú Lateral (SideMenu) actúa como el orquestador principal, permitiendo la redirección instantánea entre el Dashboard, el Directorio de Proveedores y la Configuración de Perfil, cerrándose automáticamente para reenfocar al usuario en la tarea actual.

🛠️ Stack Tecnológico y Estándares
Flutter SDK: Framework principal para la interfaz multiplataforma.

Rive: Motor de animación vectorial interactiva de baja latencia.

Provider: Gestión de estado reactiva para la autenticación y flujo de datos.

Intl & Equatable: Estándares de la industria para el formateo de moneda/fechas y la comparación eficiente de modelos de datos.

Clean Code: Implementación estricta de principios SOLID y funciones de flecha para un código más limpio y declarativo.

Desarrollado por Angel Castañeda
Ingeniero de Sistemas enfocado en Performance y Arquitectura Limpia.
