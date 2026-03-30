class RiveAssets {
  // Centralizamos las rutas. Si mueves una carpeta, solo cambias esto aquí.
  static const String _basePath = "assets/samples/ui/rive_app/rive";

  static const String shapes = "$_basePath/shapes.riv";
  static const String check = "$_basePath/check.riv";
  static const String icons =
      "$_basePath/icons.riv"; // Útil para tab bar animado
}

class AppImages {
  // Rutas para imágenes estáticas (PNG, JPG, WebP)
  static const String _basePath = "assets/samples/ui/rive_app/images";

  static const String spline = "$_basePath/backgrounds/spline.png";
  static const String logo = "$_basePath/logo_connexa.png"; // Si tienes logo
  static const String avatarPlaceholder = "$_basePath/avatar.png";
}

/// Centralizamos también animaciones Lottie si llegas a usar.
class AppAnimations {
  static const String _basePath = "assets/animations";

  static const String success = "$_basePath/success_check.json";
  static const String error = "$_basePath/error_cross.json";
}
