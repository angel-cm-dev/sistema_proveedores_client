# 🏢 Connexa: Enterprise Supplier Management System

[![Flutter](https://img.shields.io/badge/Flutter-3.27+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Feature--Driven%20Clean-FF6F00?logo=architecture&logoColor=white)](#-arquitectura-feature-driven-clean-architecture)
[![Animation](https://img.shields.io/badge/UI--UX-Rive%203D%20Spatial-black?logo=rive&logoColor=white)](#-ingeniería-visual-y-spatial-ui)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Connexa** es una solución de gestión empresarial de alto rendimiento diseñada para optimizar la cadena de suministro. Este cliente frontend redefine la experiencia de usuario corporativa mediante la convergencia de una **Arquitectura Limpia** y un paradigma de **Spatial UI** (Interfaz Espacial).

---

## 🏗️ Arquitectura: Feature-Driven Clean Architecture

El sistema ha sido migrado a una estructura orientada a dominios funcionales, permitiendo un **escalamiento horizontal desacoplado**. Esta arquitectura garantiza que cada característica sea una unidad lógica independiente, facilitando el mantenimiento y la inyectividad de dependencias.

### 📁 Anatomía del Proyecto (`/lib`)

* **`core/`**: El motor del sistema. Implementa modelos de datos inmutables, gestión centralizada de `Themes`, `Assets` y utilitarios globales.
* **`features/`**: Módulos de negocio independientes:
    * **Auth**: Flujos de seguridad, validación OTP y persistencia de sesión.
    * **Suppliers**: Directorio inteligente con búsqueda indexada y vistas detalladas.
    * **Orders**: Orquestación de transacciones y trazabilidad de estados.
    * **Notifications**: Centro de eventos con lógica de recuperación (Undo/Redo).
    * **Profile**: Gestión de identidad mediante componentes expandibles y reactivos.
* **`shared/`**: Biblioteca de componentes transversales y widgets de diseño atómico.

---

## 🎨 Ingeniería Visual y Spatial UI

Connexa no solo presenta datos; crea una atmósfera de trabajo inmersiva mediante técnicas avanzadas de renderizado en Flutter:

* **3D Navigation Shell**: Implementación de una arquitectura de capas (Layers) con **Matrix4 Transformations**. Al interactuar con el menú, el contenido principal realiza una rotación en el eje $Y$ y una reducción de escala ($0.92x$), generando una perspectiva tridimensional real.
* **Rive Hybrid Integration**: Sincronización de máquinas de estado de Rive con el `AnimationController` de Flutter. El botón de menú no es una imagen, es un activo vectorial interactivo que responde al estado de la navegación en tiempo real.
* **Hero & Motion Design**: Transiciones fluidas entre la lista y el detalle de proveedores mediante **Hero Animations**, manteniendo la continuidad visual del activo (Brand Consistency).
* **Advanced Glassmorphism**: Uso de `BackdropFilter` y `ImageFilter.blur` para una segmentación visual profunda, permitiendo que los fondos dinámicos no interfieran con la legibilidad de la data operativa.

---

## 🛡️ Hitos de Desarrollo e Implementación

### 1. Sistema de Notificaciones "Resiliente"
* **Gesticulación Avanzada**: Integración de `Dismissible` con feedback háptico para el descarte de alertas.
* **Lógica de Reversión**: Implementación de un búfer temporal que permite al usuario **"Deshacer"** acciones accidentales, mejorando la seguridad en la gestión de datos.

### 2. Gestión de Identidad Blindada
* **UserModel Senior**: El modelo de usuario incluye lógica de filtrado inteligente para asegurar la integridad de la identidad visual (`fullName` logic) y parsing robusto de tipos provenientes de la API.
* **Profile Cards**: Componentes de UI que optimizan el *real estate* de la pantalla mediante estados expandibles dinámicos.

### 3. Navegación de Baja Latencia
* **Stateful Orquestation**: El `SideMenu` actúa como un orquestador que sincroniza el `SelectedTabIndex` con las transformaciones 3D, asegurando cierres automáticos y re-enfoque de usuario sin caídas de frames (60/120 FPS).

---

## 🛠️ Stack Tecnológico y Estándares Senior

* **Flutter SDK**: Core framework optimizado para performance.
* **Rive**: Animaciones vectoriales interactivas de baja latencia.
* **Provider**: Gestión de estado reactiva y eficiente.
* **Intl & Equatable**: Estándares para internacionalización y comparación de objetos por valor (Value Equality).
* **SOLID & Clean Code**: Código escrito bajo el principio de responsabilidad única, funciones de flecha para inmutabilidad y tipado fuerte.

---

## 👨‍💻 Engineering & Development

Desarrollado con enfoque en rendimiento y escalabilidad por:

**Angel Castañeda**
*Ingeniero de Sistemas | Developer*
> "La excelencia técnica no es un acto, es un hábito basado en la arquitectura y el performance."

---
