import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importação do Firebase
import 'firebase_options.dart'; // O arquivo que o comando criou
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/providers/navigation_provider.dart';
import 'package:vans/providers/user_provider.dart';
import 'package:vans/providers/route_provider.dart';
import 'package:vans/providers/ticket_provider.dart';
import 'package:vans/providers/chat_provider.dart';
import 'routes/app_routes.dart';

void main() async {
  // 1. Garante que os plugins funcionem antes do app começar
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa o Firebase com as opções do seu projeto
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RouteProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'GoRotas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routeMap,
        onUnknownRoute: AppRoutes.unknownRoute,
      ),
    );
  }
}
