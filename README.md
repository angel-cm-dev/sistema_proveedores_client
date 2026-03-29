# 🏢 Sistema de Gestión de Proveedores - Frontend (Client)

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green?style=for-the-badge)
![SOLID](https://img.shields.io/badge/Principles-SOLID-orange?style=for-the-badge)

Este proyecto es el núcleo visual del **Sistema de Proveedores**, diseñado bajo estándares de ingeniería de software de alta calidad. El objetivo es ofrecer una plataforma robusta para la gestión logística, con una interfaz disruptiva y una arquitectura escalable.

---

## 🏗️ Arquitectura del Proyecto (Clean Architecture)

Hemos implementado una arquitectura por capas para garantizar que el código sea testeable, mantenible y desacoplado de agentes externos.

### Estructura de Directorios (`/lib`)

* **`core/`**: El corazón del sistema.
    * `assets.dart`: Centralización de rutas de recursos para evitar *Magic Strings*.
    * `constants.dart`: Definiciones globales de temas, colores y estilos.
    * `auth_provider.dart`: Lógica de negocio para la gestión de estados (Roles y Tiers).
* **`presentation/`**: Capa de Interfaz de Usuario.
    * `auth/`: Pantalla de Login y formularios animados.
    * `client/`: Dashboards y módulos específicos para el flujo del Cliente.
    * `auth_wrapper.dart`: Implementación del patrón **Guard/Portero** para ruteo dinámico basado en estado.

---

## 🎨 UI/UX & Animaciones Premium

La aplicación destaca por una experiencia visual de nivel **SaaS Corporativo**, utilizando las últimas tendencias de diseño:

1.  **Glassmorphism:** Efecto de "cristal esmerilado" mediante `BackdropFilter` con desenfoque de 30px, logrando una estética moderna y limpia.
2.  **Rive Animations:** Integración nativa de archivos `.riv` (`shapes.riv`) para fondos dinámicos que no consumen video, sino que se renderizan en tiempo real mediante vectores.
3.  **Transiciones Senior:** Uso de `showGeneralDialog` con `SlideTransition` para una navegación orgánica entre el Welcome y el Formulario de Login.

---

## 🛠️ Stack Tecnológico

| Herramienta | Propósito |
| :--- | :--- |
| **Flutter 3.11.4+** | Framework principal multiplataforma. |
| **Provider** | Gestión de estado reactiva y eficiente. |
| **Rive** | Motor de animaciones interactivas (State Machines). |
| **Flutter SVG** | Renderizado de iconografía vectorial sin pérdida de resolución. |
| **Dio** | Cliente HTTP avanzado para futuras integraciones con la API (Laravel). |

---

## 🛡️ Lógica de Roles y Niveles (SaaS Tiering)

El sistema está preparado para escalar hacia un modelo de negocio basado en suscripciones:

* **Roles:** Administrador, Operador (Staff) y Cliente.
* **Tiers (Niveles):**
    * **Free:** Acceso a funcionalidades de consulta estándar.
    * **Premium:** Acceso a herramientas avanzadas de optimización logística y reportes detallados.

```dart
// Ejemplo de inyección de estado con Provider
final auth = Provider.of<AuthProvider>(context);
if (auth.tier == UserTier.premium) {
  _enableAdvancedFeatures();
}

🚀 Requisitos e Instalación

Requisitos Previos

Flutter SDK: ^3.11.4
Android SDK: Build-Tools v35.0.0
Emulador: Pixel 8 (Recomendado para testing de Glassmorphism).

Instalación Paso a Paso

Clonar el repositorio:

Bash
git clone [https://github.com/angel-cm-dev/sistema_proveedores_client.git](https://github.com/angel-cm-dev/sistema_proveedores_client.git)

Instalar dependencias:

Bash
flutter pub get

Configurar Assets:
Verificar que la carpeta /assets contenga la jerarquía de fuentes (Poppins/Inter) y animaciones Rive detallada en la documentación interna.

Ejecutar la aplicación:
Bash
flutter run

📈 Estado de Avances (Roadmap)

[x] Configuración de Arquitectura Base y principios SOLID.
[x] Gestión de Estado Global (Roles/Tiers).
[x] UI Maquetada con Rive y Glassmorphism.
[x] Control de Versiones sincronizado en GitHub.
[ ] Implementación de Formulario de Login reactivo.
[ ] Integración con API de Autenticación (JWT - Laravel).

Desarrollado por Angel Castañeda
Sistemas & Software Development | Enfoque en Clean Code y Scalability.
