# Plan Maestro - App Connexa (Operator + Owner)

Fecha: 2026-03-31
Estado actual del repo: base Flutter funcional en etapa MVP visual
Enfoque de producto: SOLO operadores y propietarios (sin cliente final)

## 1. Objetivo del plan

Construir una app movil de operacion para proveedores con dos roles:

- Operator: gestiona ejecucion diaria (ordenes, agenda, incidencias, seguimiento)
- Owner: supervisa negocio (metricas, rendimiento, control de usuarios y decisiones)

El plan esta dividido en fases para ejecutar de forma incremental, con entregables claros, criterios de aceptacion y riesgos por fase.

## 2. Principios de ejecucion

- Entregar valor cada semana (vertical slices)
- Evitar deuda de arquitectura desde el inicio (separacion por feature)
- Definir permisos por rol desde Fase 1
- UI consistente con design tokens
- Tests minimos obligatorios por feature nueva
- Feature flags para habilitar funciones en rollout gradual

## 3. Alcance funcional (MVP)

### 3.1 Modulos comunes

- Autenticacion
- Dashboard
- Ordenes
- Proveedores
- Notificaciones
- Perfil y ajustes

### 3.2 Modulos Operator

- Operacion diaria (ordenes, calendario, incidencias)
- Seguimiento de entregas y SLA

### 3.3 Modulos Owner

- Dashboard ejecutivo
- KPI financieros/operativos
- Gestion de usuarios internos

## 4. Arquitectura objetivo

## 4.1 Capas

- Presentation: screens, widgets, controllers/notifiers
- Domain: entities, use cases, reglas de negocio
- Data: repositorios, data sources (api/local), mappers

## 4.2 Estructura recomendada

```text
lib/
  core/
    theme/
    navigation/
    errors/
    network/
    auth/
  features/
    auth/
      presentation/
      domain/
      data/
    dashboard/
    orders/
    suppliers/
    incidents/
    notifications/
    profile/
    users/               # owner only
    analytics/           # owner only
```

## 4.3 Estado y navegacion

- Estado: Provider (evolucionable a Riverpod/Bloc si crece la complejidad)
- Navegacion: router central + guards por rol
- Sesion: token seguro + refresh + expiracion + logout global

## 5. Roadmap por fases

## [x] Fase 0 - Fundacion tecnica (2-3 dias)

Objetivo:
Preparar bases para desarrollar rapido sin romper arquitectura.

Tareas:

- Definir design tokens (color, tipografia, spacing, radios, sombras)
- Estandarizar componentes base (botones, inputs, cards, chips, loaders)
- Configurar router central y layout shell
- Definir modelo de rol: operator y owner
- Crear convenciones de carpetas por feature
- Configurar entorno dev/stage/prod (variables y sabores basicos)

Entregables:

- Theme y componentes reutilizables
- Estructura de carpetas por feature
- Documento de convenciones de codigo

Criterios de aceptacion:

- App levanta en Android/iOS sin warnings criticos nuevos
- Navegacion base funcionando con ruta protegida
- Tokens de UI usados al menos en welcome y auth

Riesgos:

- Over-engineering temprano
- Mitigacion: limitar fundacion a lo estrictamente necesario para Fase 1

---

## [x] Fase 1 - Auth y control por roles (4-5 dias)

Objetivo:
Implementar flujo de acceso completo para usuarios internos.

Vistas:

- Welcome
- Iniciar sesion
- Crear cuenta (si aplica onboarding interno)
- Olvide mi contrasena
- Restablecer contrasena
- Verificacion de correo/OTP (si backend lo requiere)

Tareas:

- Formularios con validaciones robustas
- Integracion con API auth (o mock realista en paralelo)
- Persistencia segura de sesion
- Guard de rutas por rol
- Logout y expiracion de token
- Manejo de errores (credenciales invalidas, timeout, sin internet)

Entregables:

- Flujo auth end-to-end
- Redireccion por rol (operator/owner)
- Estados UI: loading, error, success

Criterios de aceptacion:

- Usuario operator entra a dashboard operator
- Usuario owner entra a dashboard owner
- Logout limpia sesion y bloquea rutas privadas

Riesgos:

- Dependencia de backend auth
- Mitigacion: mock server con contratos versionados

---

## [x] Fase 2 - Dashboard Operator + shell de navegacion (4-5 dias)

Objetivo:
Dar al operator una vista de trabajo diario util.

Vistas:

- Dashboard Operator
- Bottom nav tabs: Home, Calendario, Ordenes, Perfil

Tareas:

- KPI operativos (ordenes hoy, atrasos, incidencias abiertas)
- Lista de ordenes recientes con estado
- CTA de accion rapida (crear incidencia, ver ordenes criticas)
- Notificaciones top bar
- Transiciones y rendimiento de lista

Entregables:

- Dashboard operator funcional con datos mock/API
- Navegacion por tabs persistiendo estado basico

Criterios de aceptacion:

- Operator puede completar su flujo diario minimo desde Home
- Carga inicial menor a 2.5s en dispositivo de prueba

Riesgos:

- UI pesada (blur/animaciones)
- Mitigacion: medir frames y limitar efectos en pantallas densas

---

## [x] Fase 3 - Ordenes e incidencias (5-6 dias)

Objetivo:
Resolver el nucleo operativo de ejecucion y control.

Vistas:

- Lista de ordenes
- Detalle de orden
- Filtros avanzados
- Crear/editar incidencia
- Seguimiento de incidencia

Tareas:

- Modelo Order + estados de ciclo de vida
- Filtros por estado, prioridad, fecha, proveedor
- Timeline/historial de cambios en detalle
- Adjuntos basicos (foto/comentario) para incidencia
- Reglas de negocio (transiciones validas)

Entregables:

- Gestion operativa de ordenes
- Flujo de incidencias conectado a orden

Criterios de aceptacion:

- Cambios de estado validos y auditables
- Filtros responden en menos de 400ms con dataset de prueba

Riesgos:

- Complejidad de reglas de estado
- Mitigacion: tabla de estados y pruebas unitarias de use cases

---

## [x] Fase 4 - Proveedores + calendario (4-5 dias)

Objetivo:
Completar gestion de red de proveedores y planificacion temporal.

Vistas:

- Lista de proveedores
- Detalle de proveedor
- Calendar view (entregas, visitas, hitos)

Tareas:

- Perfil proveedor (contacto, cumplimiento, score)
- Relacion proveedor <-> ordenes
- Agenda con eventos por dia/semana
- Alertas por eventos proximos

Entregables:

- Modulo proveedores navegable
- Calendario operativo funcional

Criterios de aceptacion:

- Operator puede abrir proveedor desde orden
- Eventos se visualizan con filtros por tipo

Riesgos:

- Consistencia de datos proveedor-orden
- Mitigacion: ids unificados y mappers tipados

---

## [x] Fase 5 - Dashboard Owner + administracion interna (5-6 dias)

Objetivo:
Habilitar supervision de negocio para propietario.

Vistas:

- Dashboard Owner (KPI ejecutivos)
- Modulo usuarios internos
- Panel de rendimiento por proveedor

Tareas:

- KPI de negocio (cumplimiento SLA, tiempo promedio, incidencias por periodo)
- Gestion de usuarios (alta, baja, cambio de rol)
- Reportes resumidos exportables (CSV/PDF en iteracion posterior)
- Permisos owner-only en rutas y acciones

Entregables:

- Dashboard diferenciado por rol owner
- Modulo usuarios internos minimo

Criterios de aceptacion:

- Owner ve informacion agregada distinta de operator
- Owner administra usuarios sin exponer funciones a operator

Riesgos:

- Control de permisos incompleto
- Mitigacion: matriz de permisos + tests de autorizacion

---

## [x] Fase 6 - Calidad, seguridad y release interno (3-4 dias)

Objetivo:
Llegar a una version estable para piloto.

Tareas:

- Corregir warnings/deprecaciones
- Tests: unit, widget, smoke e2e minimo
- Instrumentacion de logs y observabilidad
- Hardening de red (timeouts, retries, circuit breaker simple)
- Configuracion release signing y checklist de despliegue

Entregables:

- Build candidata a piloto
- Reporte de calidad y riesgos residuales

Criterios de aceptacion:

- Suite minima de tests en verde
- Crash-free en pruebas internas de humo
- Build release instalada en entorno de QA

Riesgos:

- Bugs de integracion tardios
- Mitigacion: congelamiento de features y bug bash de 1 dia

---

## [x] Fase 7 - Vistas comunes faltantes (2-3 dias)

Objetivo:
Completar vistas compartidas entre roles.

Vistas:

- Pantalla de notificaciones (con badge, marcar leido)
- Pantalla de ajustes (tema, notificaciones, seguridad, version)
- Wiring de navegacion: bell icon en Home, settings en Profile

Entregables:

- NotificationsScreen con mock data y read/unread
- SettingsScreen con toggles de tema, notificaciones y secciones informativas

---

## [x] Fase 8 - Testing minimo y pulido (2-3 dias)

Objetivo:
Suite minima de tests y estabilidad.

Tareas:

- Unit tests: AuthController (login, logout, session, errors)
- Unit tests: Order state transition rules + isOverdue
- Widget/logic tests: login flow, role guard routing
- Smoke test basico (enum coverage)
- Fix deprecaciones withOpacity -> withValues (95 ocurrencias)

Entregables:

- 26 tests en verde (15 unit + 9 logic + 2 smoke)
- 0 errors, 0 warnings en flutter analyze

---

## [x] Fase 9 - Repositorios y cliente API (3-4 dias)

Objetivo:
Completar capa de datos con repositorios tipados y cliente HTTP listo para backend real.

Tareas:
- AppEnvironment (dev/staging/prod) con base URL y timeouts
- ApiClient con Dio: interceptors de auth, logging y error mapping
- Repository interfaces: OrderRepository, IncidentRepository, SupplierRepository, OwnerRepository
- Repository implementations con mock datasource (swap a API real sin cambiar presentation)
- Models con JSON serialization: OrderModel, IncidentModel, SupplierModel
- ServiceLocator para dependency injection sin paquete externo

Entregables:
- Capa data completa con contratos versionados
- DI funcional con ServiceLocator singleton

---

## [x] Fase 10 - Busqueda global y paginacion (2-3 dias)

Objetivo:
Busqueda cross-feature y herramientas de filtrado avanzado.

Tareas:
- GlobalSearchDelegate (busca en ordenes, proveedores, incidencias)
- PaginatedListMixin reutilizable con scroll-to-load-more
- DateRangeFilter widget con date range picker
- Wiring: icono de busqueda en OperatorHomeScreen y OwnerDashboardScreen

Entregables:
- Busqueda global funcional desde ambos shells
- Componentes reutilizables de paginacion y filtros de fecha

---

## [x] Fase 11 - Auth completo y onboarding (3-4 dias)

Objetivo:
Completar flujos de autenticacion faltantes y primera experiencia de usuario.

Vistas:
- RegisterScreen (crear cuenta con validaciones)
- ResetPasswordScreen (OTP 6 digitos + nueva contrasena)
- ChangePasswordScreen (desde perfil, con contrasena actual)
- OnboardingScreen (carousel 3 slides: ordenes, proveedores, KPIs)

Tareas:
- Glassmorphism consistente con login/forgot password
- Link "Registrate" en login screen
- Rutas registradas en main.dart (register, change-password)
- Validaciones robustas (nombre+apellido, match passwords, min 6 chars)

Visual refresh (inspirado en example/):
- SuppliersScreen: cards con gradiente por proveedor, featured horizontal, chips por categoria
- NotificationsScreen: cards con tinte de color por tipo, header bold

Entregables:
- 4 nuevas pantallas de auth + onboarding
- Visual refresh de proveedores y notificaciones

---

## [x] Fase 12 - Reportes exportables y adjuntos (2-3 dias)

Objetivo:
Exportacion de datos operativos y evidencia fotografica en incidencias.

Tareas:
- ReportExportService: generador CSV con escape de campos
- ReportsScreen: UI para exportar ordenes, proveedores, incidencias, rendimiento
- Share via share_plus para compartir archivos CSV
- AttachmentPicker: image_picker con camara/galeria, preview, max 5 adjuntos
- Dependencias: path_provider, share_plus, image_picker

Entregables:
- Exportacion CSV funcional de 4 tipos de reporte
- Picker de adjuntos listo para integrar en formulario de incidencias

---

## 6. Lista de vistas final sugerida

## 6.1 Comunes

- Splash
- Welcome
- Login
- Registro
- Olvide mi contrasena
- Restablecer contrasena
- Notificaciones
- Perfil
- Ajustes

## 6.2 Operator

- Dashboard Operator
- Ordenes (lista)
- Orden (detalle)
- Incidencias (lista/formulario)
- Calendario operativo
- Proveedores (lista/detalle)

## 6.3 Owner

- Dashboard Owner
- Usuarios internos
- Reportes/KPI
- Rendimiento proveedores

## 7. Matriz de permisos minima

- Operator:
  - Ver/actualizar ordenes
  - Crear/gestionar incidencias
  - Ver proveedores
  - No administra usuarios internos
- Owner:
  - Todo lo de operator
  - Gestion usuarios internos
  - Ver panel ejecutivo y metricas agregadas

## 8. Definicion de done (DoD)

Una historia se considera terminada cuando:

- Cumple criterio funcional y UX definido
- Tiene manejo de loading/error/empty
- Incluye tests minimos (unit o widget segun aplique)
- Respeta permisos por rol
- No introduce warnings criticos en analyze

## 9. Plan de testing minimo

- Unit:
  - use cases de auth
  - reglas de transicion de estados de orden
- Widget:
  - login form + validaciones
  - dashboard operator render basico
  - guard de rutas por rol
- Integracion (smoke):
  - login -> dashboard -> orden detalle -> logout

## 10. KPI de producto para piloto

- Tiempo medio de login exitoso
- Tiempo de carga dashboard
- Ordenes gestionadas por operador/dia
- Incidencias resueltas en SLA
- Crash-free sessions

## 11. Cronograma sugerido

Escenario rapido (MVP): 4-5 semanas

- Semana 1: Fase 0 + Fase 1
- Semana 2: Fase 2
- Semana 3: Fase 3
- Semana 4: Fase 4 + inicio Fase 5
- Semana 5: cierre Fase 5 + Fase 6

Escenario robusto: 6-8 semanas (incluyendo reportes avanzados y optimizacion)

## 12. Primer sprint recomendado (inmediato)

Objetivo sprint 1:
Dejar auth + enrutamiento por rol listos para operar sobre una base estable.

Backlog sprint 1:

- Refactor rutas por rol operator/owner
- Completar vistas auth faltantes
- Integrar sesion segura
- Corregir tests base y warnings actuales
- Publicar documento de convenciones tecnicas

Resultado esperado sprint 1:

- Usuario interno entra, se enruta por rol y puede cerrar sesion de forma segura
- Proyecto listo para iterar rapido en modulos operativos
