import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/navigation/route_names.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/data/datasources/auth_mock_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/entities/user_entity.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/screens/change_password_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/welcome_screen.dart';
import 'features/operator/presentation/shell/operator_shell.dart';
import 'features/owner/presentation/shell/owner_shell.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(
          create: (_) =>
              AuthController(AuthRepositoryImpl(AuthMockDataSource())),
        ),
      ],
      child: const ConnexaApp(),
    ),
  );
}

class ConnexaApp extends StatelessWidget {
  const ConnexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connexa',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeCtrl.mode,
      // ── Raíz reactiva: Consumer decide la pantalla según el estado de auth ──
      home: const _AppRoot(),
      // ── Rutas adicionales para push desde la raíz ──────────────────────
      routes: {
        RouteNames.login: (_) => const LoginScreen(),
        RouteNames.register: (_) => const RegisterScreen(),
        RouteNames.forgotPassword: (_) => const ForgotPasswordScreen(),
        RouteNames.changePassword: (_) => const ChangePasswordScreen(),
        RouteNames.operator: (_) => const OperatorShell(),
        RouteNames.owner: (_) => const OwnerShell(),
      },
    );
  }
}

/// Raíz reactiva que escucha el AuthController y muestra la pantalla correcta.
/// - initial:       splash (indicador de carga)
/// - authenticated: dashboard por rol
/// - unauthenticated/error: welcome
class _AppRoot extends StatelessWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return switch (auth.status) {
      AuthStatus.initial => const _SplashView(),
      AuthStatus.authenticated => _dashboardByRole(auth.currentUser!.role),
      _ => const WelcomeScreen(),
    };
  }

  Widget _dashboardByRole(UserRole role) => switch (role) {
    UserRole.owner => const OwnerShell(),
    UserRole.operator => const OperatorShell(),
  };
}

/// Pantalla de carga mientras se verifica la sesión persistida
class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: AppColors.gradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.link_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
