import 'package:flutter/material.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../screens/forgot_password.dart';
import '../screens/add_card.dart';
import '../screens/add_pix.dart';
import '../screens/chat.dart';
import '../screens/private_chat.dart';
import '../screens/search.dart';
import '../screens/results.dart';
import '../screens/passage_details.dart';
import '../screens/payment.dart';
import '../screens/receipt.dart';
import '../screens/rating.dart';
import '../screens/tickets.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String addCard = '/add-card';
  static const String addPix = '/add-pix';
  static const String chat = '/chat';
  static const String privateChat = '/private-chat';
  static const String search = '/search';
  static const String results = '/results';
  static const String passageDetails = '/passage-details';
  static const String payment = '/payment';
  static const String receipt = '/receipt';
  static const String rating = '/rating';
  static const String tickets = '/tickets';

  static final Map<String, WidgetBuilder> routeMap = {
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    addCard: (_) => const AddCardScreen(),
    addPix: (_) => const AddPixScreen(),
    chat: (_) => const ChatScreen(),
    privateChat: (_) => PrivateChatScreen(driverName: ''), // driverName deve ser passado via argumentos
    search: (_) => const SearchScreen(),
    results: (_) => const ResultsScreen(),
    passageDetails: (_) => PassageDetailsScreen(
      origin: '', destination: '', type: '', price: 0, date: '', departureTime: '', rating: 0, driverName: '', driverRating: '', driverTrips: 0), // argumentos via settings
    payment: (_) => PaymentScreen(ticketPrice: 0), // ticketPrice via argumentos
    receipt: (_) => ReceiptScreen(
      origin: '', destination: '', type: '', price: 0, date: '', time: '', passengerName: '', passengerId: '', seatNumber: ''), // argumentos via settings
    rating: (_) => RatingScreen(tripType: ''), // tripType via argumentos
    tickets: (_) => const TicketsScreen(),
  };

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Rota não encontrada')),
        body: Center(
          child: Text('Rota "${settings.name}" não encontrada.'),
        ),
      ),
    );
  }
}
