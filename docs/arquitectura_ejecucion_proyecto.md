# Guía técnica del proyecto: ejecución, arquitectura y división interna

## 1. Propósito del proyecto

`Sistema Proveedores Client` es una aplicación Flutter multiplataforma orientada a la gestión operativa y ejecutiva de un sistema de proveedores.

Actualmente, el producto está organizado alrededor de dos roles principales:

- `operator`: usuario operativo que trabaja con órdenes, calendario, incidencias y proveedores.
- `owner`: usuario con vista ejecutiva para KPIs, rendimiento y gestión interna.

La solución está implementada con Flutter y sigue una estructura basada en `features`, con una intención clara de `Clean Architecture`, aunque en el estado actual todavía conviven partes desacopladas con pantallas que consumen datos mock de forma directa.

---

## 2. Stack técnico actual

### 2.1 Framework y lenguaje

- `Flutter`
- `Dart`

### 2.2 Gestión de estado

- `provider`

### 2.3 Red, persistencia y utilidades

- `dio`: cliente HTTP centralizado para integración con backend real.
- `flutter_secure_storage`: persistencia segura de sesión.
- `connectivity_plus`: base para manejo de conectividad.
- `path_provider`: acceso a directorios temporales/locales.
- `share_plus`: compartir archivos exportados.
- `image_picker`: captura/selección de imágenes para adjuntos.
- `logger`: soporte para logging interno.

### 2.4 UI y experiencia visual

- `google_fonts`
- `flutter_svg`
- `rive`
- `Material 3`

---

## 3. Requisitos del proyecto

## 3.1 Requisitos de software

Para ejecutar y mantener el proyecto se requiere, como mínimo:

- `Flutter SDK` compatible con la restricción declarada en `pubspec.yaml`.
- `Dart SDK` compatible con `sdk: ^3.11.4`.
- `Git` para clonar y versionar el repositorio.

## 3.2 Requisitos para Android

- `Android Studio` o un entorno con Android SDK configurado.
- `JDK 17`, alineado con la configuración de `android/app/build.gradle.kts`.
- SDKs de Android instalados para compilar con la versión que resuelva Flutter en `flutter.compileSdkVersion`.

## 3.3 Requisitos para iOS

La compilación iOS solo puede validarse desde macOS. Para ello se requiere:

- `macOS`
- `Xcode`
- `CocoaPods`
- Toolchain de iOS compatible con `iOS 13.0`, que es el deployment target actual del proyecto.

Además, este proyecto depende de plugins Flutter que requieren integración nativa vía CocoaPods en iOS, por ejemplo:

- `flutter_secure_storage`
- `image_picker`
- `share_plus`
- `path_provider`
- `connectivity_plus`

## 3.4 Requisitos funcionales del entorno

- Acceso a los assets registrados en `pubspec.yaml`
- Dependencias descargadas con `flutter pub get`
- Para iOS, instalación de pods con `pod install` dentro de `ios/`

---

## 4. Estructura general del repositorio

La estructura principal del proyecto es la siguiente:

```text
sistema_proveedores_client/
  android/
  ios/
  lib/
    core/
    features/
    main.dart
  test/
  docs/
  pubspec.yaml
```

### 4.1 Directorios principales

- `android/`: configuración nativa Android.
- `ios/`: configuración nativa iOS.
- `lib/`: código fuente principal de la app.
- `test/`: pruebas unitarias, widget y smoke tests.
- `docs/`: documentación funcional y técnica.
- `pubspec.yaml`: manifiesto de dependencias, assets y fuentes.

---

## 5. División interna de `lib/`

## 5.1 Punto de entrada

El punto de entrada es:

- `lib/main.dart`

Desde este archivo se inicializa la app, se registran los `providers` globales y se define el `MaterialApp` con rutas y control de acceso por rol.

## 5.2 Capa `core/`

`core/` contiene infraestructura transversal y utilidades compartidas por múltiples módulos.

### Submódulos identificados

- `assets/`: referencias centralizadas a recursos.
- `config/`: variables y configuración de entorno.
- `di/`: utilidades de inyección de dependencias.
- `errors/`: jerarquía de fallos tipados (`Failure`).
- `navigation/`: constantes de rutas.
- `network/`: cliente HTTP e infraestructura de red.
- `services/`: servicios compartidos, como exportación de reportes.
- `theme/`: temas, design tokens y controlador del modo claro/oscuro.
- `utils/`: logging y utilidades varias.

## 5.3 Capa `features/`

La aplicación está organizada por funcionalidades de negocio.

### Features actuales

- `auth/`
- `common/`
- `operator/`
- `owner/`

Cada feature, cuando aplica, se divide en:

- `data/`
- `domain/`
- `presentation/`

Esto refleja una estructura orientada a `Clean Architecture`.

---

## 6. Arquitectura técnica actual

## 6.1 Patrón predominante

El proyecto sigue una aproximación híbrida con estas características:

- Separación por `feature`
- División en capas `presentation`, `domain` y `data`
- Uso de `Provider` con controladores basados en `ChangeNotifier`
- Infraestructura transversal en `core`

## 6.2 Capas y responsabilidades

### `presentation`

Responsable de:

- pantallas
- widgets
- shells de navegación
- controladores visuales
- binding con `Provider`

Ejemplos:

- `AuthController`
- `OperatorShell`
- `OwnerShell`
- pantallas de login, dashboard, órdenes, incidencias, proveedores y perfil

### `domain`

Responsable de:

- entidades de negocio
- contratos de repositorio
- reglas semánticas del dominio

Ejemplos:

- `UserEntity`
- interfaces de repositorio de autenticación y módulos de negocio

### `data`

Responsable de:

- implementaciones de repositorios
- data sources mock
- modelos serializables
- adaptación entre infraestructura y dominio

Ejemplos:

- `AuthRepositoryImpl`
- `AuthMockDataSource`
- repositorios y datasources de `operator` y `owner`

## 6.3 Observación importante sobre el estado real

Aunque la arquitectura apunta a una separación limpia, el estado actual del proyecto todavía mezcla dos enfoques:

- algunas piezas usan repositorios e interfaces correctamente
- otras pantallas consumen `MockDataSource` directamente desde `presentation`

Esto se observa, por ejemplo, en vistas de `operator` y `owner` que crean instancias de `OperatorMockDataSource` u `OwnerMockDataSource` dentro del propio estado de la pantalla.

Técnicamente, esto significa que el proyecto está en una etapa intermedia entre un MVP visual funcional y una arquitectura completamente desacoplada.

---

## 7. Flujo de ejecución de la aplicación

## 7.1 Arranque (`main`)

El flujo arranca en `main.dart`:

1. Flutter ejecuta `main()`.
2. Se crea un `MultiProvider` global.
3. Se registran dependencias reactivas compartidas.
4. Se renderiza `ConnexaApp`.

Los providers globales actuales son:

- `ThemeController`
- `AuthController`

`AuthController` se construye con:

- `AuthRepositoryImpl`
- `AuthMockDataSource`

## 7.2 Construcción de la aplicación raíz

`ConnexaApp` configura:

- `MaterialApp`
- tema claro y oscuro
- `themeMode` dinámico
- rutas nombradas
- vista raíz reactiva (`_AppRoot`)

## 7.3 Resolución de la pantalla inicial

La clase `_AppRoot` escucha el estado de `AuthController`.

Según `auth.status`, la app decide:

- `AuthStatus.initial` -> mostrar splash de carga
- `AuthStatus.authenticated` -> abrir shell según rol
- cualquier otro estado -> mostrar `WelcomeScreen`

## 7.4 Verificación de sesión

Al inicializarse, `AuthController` ejecuta `_checkSession()`.

Este proceso:

1. consulta el repositorio de autenticación
2. intenta recuperar una sesión persistida
3. actualiza el estado global de autenticación
4. dispara `notifyListeners()` para rehacer la UI

## 7.5 Enrutamiento por rol

Cuando la sesión es válida:

- si el usuario tiene rol `owner`, se carga `OwnerShell`
- si el usuario tiene rol `operator`, se carga `OperatorShell`

Además, las rutas sensibles están protegidas mediante `_RoleProtectedRoute`, que valida:

- que exista sesión
- que el usuario no esté en estado de carga
- que el rol coincida con la ruta solicitada

Si el rol no coincide, se muestra una vista de acceso restringido.

---

## 8. Flujo de autenticación

## 8.1 Implementación actual

La autenticación actual está soportada por un datasource mock:

- `features/auth/data/datasources/auth_mock_datasource.dart`

Este datasource simula login, registro, sesión persistida y logout.

## 8.2 Persistencia de sesión

La sesión se persiste con `flutter_secure_storage` usando:

- clave de sesión
- clave de expiración
- TTL de sesión de 8 horas

Esto permite:

- recuperar sesión al abrir la app
- invalidar sesión expirada
- limpiar sesión al cerrar sesión

## 8.3 Credenciales de prueba disponibles

El datasource mock incluye usuarios para testing:

- `operator@connexa.app / pass123`
- `owner@connexa.app / pass123`

## 8.4 Manejo de errores

Los errores de autenticación y red se traducen a una jerarquía de `Failure` en `core/errors/failures.dart`.

Ejemplos:

- `InvalidCredentialsFailure`
- `EmailAlreadyInUseFailure`
- `NetworkFailure`
- `SessionExpiredFailure`
- `UnknownFailure`

---

## 9. Navegación y shells

## 9.1 Rutas centralizadas

Las rutas nombradas están centralizadas en:

- `core/navigation/route_names.dart`

Rutas principales:

- `/`
- `/login`
- `/register`
- `/forgot-password`
- `/change-password`
- `/operator`
- `/owner`

## 9.2 Shell del operador

`OperatorShell` es el contenedor principal del rol operativo.

Organiza la experiencia con:

- `IndexedStack`
- barra inferior personalizada construida sobre `Container`, `Row` y widgets `_NavIcon`
- `Drawer` lateral

Pantallas principales del shell:

- `OperatorHomeScreen`
- `CalendarScreen`
- `OrdersScreen`
- `SuppliersScreen`
- `ProfileScreen`

## 9.3 Shell del owner

`OwnerShell` es el contenedor principal del rol ejecutivo.

También usa `IndexedStack` para preservar estado entre pestañas.

Pantallas principales del shell:

- `OwnerDashboardScreen`
- `SupplierPerformanceScreen`
- `UsersScreen`
- `OwnerProfileScreen`

Adicionalmente, el feature `owner` contiene una pantalla de reportes exportables.

---

## 10. Módulos funcionales por feature

## 10.1 `features/auth`

Contiene el flujo de autenticación y acceso.

### División interna

- `data/`: datasource, modelos y repositorio
- `domain/`: entidad `UserEntity` y contrato de repositorio
- `presentation/`: controlador, pantallas y widgets

### Responsabilidades

- login
- registro
- recuperación/cambio de contraseña
- sesión persistida
- enrutamiento por rol

## 10.2 `features/operator`

Agrupa la operación diaria del usuario operativo.

### Subáreas visibles

- `home/`
- `calendar/`
- `orders/`
- `incidents/`
- `suppliers/`
- `profile/`
- `shell/`
- `widgets/`

### Responsabilidades

- dashboard operativo
- consulta de órdenes
- detalle de orden
- gestión de incidencias
- agenda/calendario
- consulta de proveedores
- perfil del operador

## 10.3 `features/owner`

Agrupa las vistas ejecutivas y administrativas.

### Subáreas visibles

- `dashboard/`
- `performance/`
- `reports/`
- `users/`
- `profile/`
- `shell/`

### Responsabilidades

- KPIs ejecutivos
- rendimiento de proveedores
- gestión de usuarios internos
- exportación de reportes
- perfil del propietario

## 10.4 `features/common`

Contiene componentes compartidos entre roles.

### Tipos de contenido detectados

- `screens/`
- `widgets/`
- `mixins/`

Su función es alojar piezas reutilizables que no pertenecen exclusivamente a `operator` o `owner`.

---

## 11. Tema, diseño y consistencia visual

La app centraliza sus design tokens en:

- `core/theme/app_theme.dart`

### Elementos definidos

- paleta de colores de marca
- colores semánticos
- temas claro/oscuro
- tipografía con `Poppins` e `Inter`
- estilos globales de `AppBar`, `Button`, `Input`, `Card`, `Chip` y `BottomNavigationBar`

El estado del tema se controla con:

- `core/theme/theme_controller.dart`

Ese controlador permite:

- alternar entre modo claro y oscuro
- notificar a toda la app vía `Provider`

---

## 12. Infraestructura de red

Aunque el proyecto opera mayormente con mocks para datos de negocio, ya existe una base preparada para backend real en:

- `core/network/api_client.dart`

### Capacidades del `ApiClient`

- cliente HTTP sobre `Dio`
- `BaseOptions` centralizados
- interceptor de autenticación
- interceptor de logging
- interceptor de manejo de errores
- mapeo de errores HTTP a `Failure`

### Implicación técnica

La presencia de `ApiClient` indica que el proyecto ya tiene una base para migrar desde mocks hacia integración real, sin necesidad de rediseñar toda la infraestructura de red.

---

## 13. Servicios transversales

Un servicio transversal relevante es:

- `core/services/report_export_service.dart`

### Responsabilidades

- generar CSV desde estructuras tabulares
- escapar correctamente campos con comas, comillas o saltos de línea
- escribir archivos en directorio temporal
- devolver la ruta del archivo exportado

Este servicio se usa como base para reportes exportables desde el módulo `owner`.

---

## 14. Assets y recursos visuales

En `pubspec.yaml` están registrados:

- fuentes personalizadas (`Poppins`, `Inter`)
- assets de animaciones
- recursos de ejemplo con `Rive`
- imágenes de UI

Esto significa que la app depende de una capa visual cuidada y de una carga correcta de recursos estáticos para funcionar y renderizarse según lo esperado.

---

## 15. Estrategia de pruebas

El proyecto cuenta con carpeta `test/` dividida en:

- `unit/`
- `widget/`
- `smoke/`
- `widget_test.dart`

Esto sugiere una estrategia mínima de validación compuesta por:

- pruebas de lógica de negocio
- pruebas de widgets
- pruebas de humo sobre flujos clave

---

## 16. Estado técnico actual del proyecto

## 16.1 Fortalezas

- Estructura clara por features
- Base de `Clean Architecture`
- Soporte de roles bien definido
- Ruta raíz reactiva según sesión
- Tema global centralizado
- Infraestructura preparada para backend real
- Persistencia segura de sesión
- Preparación para exportación y adjuntos

## 16.2 Limitaciones o transiciones actuales

- Parte de la app sigue dependiendo de `MockDataSource`
- No toda la capa `presentation` consume repositorios de forma homogénea
- La integración con backend real aún no es el camino predominante
- iOS requiere toolchain macOS/Xcode/CocoaPods para validación real

---

## 17. Cómo ejecutar el proyecto

## 17.1 Preparación inicial

Desde la raíz del repositorio:

```bash
flutter pub get
```

## 17.2 Ejecutar en Android

```bash
flutter run
```

O bien, seleccionando un dispositivo/emulador Android concreto.

## 17.3 Ejecutar en iOS

Solo desde macOS:

```bash
flutter pub get
cd ios
pod install
cd ..
flutter run
```

También puede abrirse:

- `ios/Runner.xcworkspace`

mediante Xcode para compilar y depurar la app iOS.

## 17.4 Compilar artefactos

### Android

```bash
flutter build apk
```

### iOS

```bash
flutter build ios
```

---

## 18. Flujo resumido de ejecución

```text
main()
  -> MultiProvider
    -> ThemeController
    -> AuthController(AuthRepositoryImpl(AuthMockDataSource))
      -> ConnexaApp
        -> MaterialApp
          -> _AppRoot
            -> valida estado de sesión
              -> WelcomeScreen | Splash | OwnerShell | OperatorShell
```

---

## 19. Recomendaciones técnicas para evolución

A partir del estado actual, la evolución natural del proyecto sería:

- completar la inversión de dependencias en todas las pantallas
- reemplazar consumo directo de mocks por repositorios inyectados
- conectar `ApiClient` con datasources remotos reales
- centralizar navegación avanzada en un router más robusto si crece la complejidad
- ampliar la cobertura de tests sobre flujos por rol
- formalizar DI en toda la aplicación, no solo de forma parcial

---

## 20. Conclusión

Este proyecto ya dispone de una base sólida para una app Flutter empresarial orientada a operación y supervisión de proveedores.

Su arquitectura actual combina:

- una organización modular por `features`
- una base de `Clean Architecture`
- control de sesión y rol
- theming global
- infraestructura de red preparada
- utilidades reales de exportación y persistencia

El siguiente paso técnico natural es reducir el acoplamiento restante en la capa de presentación y completar la migración desde mocks hacia repositorios e integración real con backend.
