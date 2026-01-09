import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String addCard = '/add-card';
  static const String addPix = '/add-pix';
  static const String profile = '/profile';

  static final Map<String, WidgetBuilder> routeMap = {
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    home: (_) => const HomePage(),
    addCard: (_) => const AddCardScreen(),
    addPix: (_) => const AddPixScreen(),
    profile: (_) => const ProfileScreen(),
  };

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Rota não encontrada')),
        body: Center(child: Text('Rota "${settings.name}" não encontrada.')),
      ),
    );
  }
}
