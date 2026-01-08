import 'package:flutter/material.dart';

enum AppScreen {
  search,
  tickets,
  chat,
  menu,
  results,
  passageDetails,
  payment,
  receipt,
  rating,
  privateChat,
}

class NavigationProvider extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.search;
  String _headerTitle = 'GoRotas';
  bool _showBackButton = false;

  // Dados para navegação entre telas
  Map<String, dynamic> _screenData = {};

  // Histórico de navegação para o botão voltar
  final List<AppScreen> _navigationHistory = [];

  AppScreen get currentScreen => _currentScreen;
  String get headerTitle => _headerTitle;
  bool get showBackButton => _showBackButton;
  Map<String, dynamic> get screenData => _screenData;

  void navigateTo(
    AppScreen screen, {
    String? title,
    Map<String, dynamic>? data,
    bool addToHistory = true,
  }) {
    if (addToHistory && _currentScreen != screen) {
      _navigationHistory.add(_currentScreen);
    }

    _currentScreen = screen;
    _screenData = data ?? {};

    // Define títulos padrão para cada tela
    _headerTitle = title ?? _getDefaultTitle(screen);
    _showBackButton = _navigationHistory.isNotEmpty;

    notifyListeners();
  }

  void goBack() {
    if (_navigationHistory.isNotEmpty) {
      _currentScreen = _navigationHistory.removeLast();
      _headerTitle = _getDefaultTitle(_currentScreen);
      _showBackButton = _navigationHistory.isNotEmpty;
      _screenData = {};
      notifyListeners();
    }
  }

  void resetToHome() {
    _navigationHistory.clear();
    _currentScreen = AppScreen.search;
    _headerTitle = 'GoRotas';
    _showBackButton = false;
    _screenData = {};
    notifyListeners();
  }

  String _getDefaultTitle(AppScreen screen) {
    switch (screen) {
      case AppScreen.search:
        return 'GoRotas';
      case AppScreen.tickets:
        return 'Histórico de Viagens';
      case AppScreen.chat:
        return 'Conversas';
      case AppScreen.menu:
        return 'Menu';
      case AppScreen.results:
        return 'Resultado da Busca';
      case AppScreen.passageDetails:
        return 'Detalhes da Passagem';
      case AppScreen.payment:
        return 'Pagamento';
      case AppScreen.receipt:
        return 'Recibo';
      case AppScreen.rating:
        return 'Avaliação';
      case AppScreen.privateChat:
        return _screenData['driverName'] ?? 'Chat';
    }
  }

  int get bottomMenuIndex {
    switch (_currentScreen) {
      case AppScreen.search:
      case AppScreen.results:
      case AppScreen.passageDetails:
      case AppScreen.payment:
        return 0;
      case AppScreen.tickets:
      case AppScreen.receipt:
      case AppScreen.rating:
        return 1;
      case AppScreen.chat:
      case AppScreen.privateChat:
        return 2;
      case AppScreen.menu:
        return 3;
    }
  }
}
