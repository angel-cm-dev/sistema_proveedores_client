# 🏢 Sistema de Gestión de Proveedores - Frontend (Client)

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green?style=for-the-badge)

Este repositorio contiene la implementación del cliente para el Sistema de Gestión de Proveedores. El desarrollo se enfoca en una arquitectura desacoplada y una experiencia de usuario de alto impacto visual.

---

## 🏗️ Arquitectura Técnica (Current State)

El proyecto sigue los principios de **Clean Architecture**, organizando la lógica en capas para facilitar el mantenimiento y el escalamiento a niveles Senior.

### Estructura de Directorios (`/lib`)

* **`core/`**: Infraestructura base y lógica transversal.
  * `assets.dart`: Gestión centralizada de recursos (Rive, fuentes y multimedia).
  * `auth_provider.dart`: Gestión de estado reactivo mediante **Provider**. Controla la lógica de sesión y roles.
* **`presentation/`**: Capa de interfaz de usuario.
  * `auth/`: Implementación de la pantalla de bienvenida y el formulario de acceso.
  * `auth_wrapper.dart`: Orquestador de rutas (Patrón Guard). Gestiona el renderizado dinámico basado en el estado del usuario.

---

## 🎨 UI/UX: Visual Engineering

Se han implementado técnicas avanzadas de diseño para lograr una interfaz moderna y eficiente:

1. **Glassmorphism:** Uso de `BackdropFilter` con `ImageFilter.blur` para crear superficies translúcidas, optimizando el rendimiento de renderizado.
2. **Animaciones con Rive:** Integración de fondos dinámicos vectoriales (`shapes.riv`) que interactúan con la interfaz sin la sobrecarga de memoria de los archivos de video.
3. **Typography & Layout:** Implementación de Google Fonts (Poppins/Inter) y una estructura de diseño basada en `Stack` para superposición de capas visuales.

---

## 🛡️ Gestión de Estado y Flujo

El sistema utiliza **Provider** para la propagación de datos. Actualmente, el flujo de autenticación está estructurado para manejar:

* **Auth Status:** Control de entrada/salida de la aplicación.
* **Roles & Tiers:** Estructura preparada para diferenciar entre usuarios Admin/Client y niveles Free/Premium.

```dart
// Lógica de ruteo dinámico implementada en AuthWrapper
return authProvider.isAuthenticated
    ? const MainScreen()
    : const WelcomeScreen();
```
---

## 🛠️ Stack Tecnológico Implementado

| Herramienta | Aplicación |
| :--- | :--- |
| **Flutter SDK** | Core del desarrollo multiplataforma. |
| **Provider** | State management para la lógica de autenticación. |
| **Rive** | Motor de animaciones vectoriales interactivo. |
| **Google Fonts** | Gestión de tipografía corporativa. |

---

**Desarrollado por [Angel Castañeda](https://github.com/angel-cm-dev)**
*Ingeniero de Sistemas | Software Developer enfocado en Clean Code y Performance.*
