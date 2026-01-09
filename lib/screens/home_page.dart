import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/exports.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        return Scaffold(
          backgroundColor: _getBackgroundColor(navProvider.currentScreen),
          appBar: _shouldShowAppBar(navProvider.currentScreen)
              ? _buildAppBar(context, navProvider)
              : null,
          body: _buildBody(navProvider),
          bottomNavigationBar: Navbar(
            currentIndex: navProvider.navbarIndex,
            onItemSelected: (index) => _handleNavbarTap(context, index),
          ),
        );
      },
    );
  }

  bool _shouldShowAppBar(AppScreen screen) {
    // Search tem seu próprio header customizado
    return screen != AppScreen.search;
  }

  Color _getBackgroundColor(AppScreen screen) {
    switch (screen) {
      case AppScreen.search:
        return AppColors.primaryBlue;
      case AppScreen.chat:
        return AppColors.backgroudGray;
      default:
        return AppColors.white;
    }
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    NavigationProvider navProvider,
  ) {
    return AppHeader(
      title: navProvider.headerTitle,
      showBackButton: navProvider.showBackButton,
      onBackPressed: () => navProvider.goBack(),
    );
  }

  Widget _buildBody(NavigationProvider navProvider) {
    switch (navProvider.currentScreen) {
      case AppScreen.search:
        return const Search();
      case AppScreen.tickets:
        return const Tickets();
      case AppScreen.chat:
        return const Chat();
      case AppScreen.menu:
        return const Menu();
      case AppScreen.results:
        return const Results();
      case AppScreen.passageDetails:
        return PassageDetails(data: navProvider.screenData);
      case AppScreen.payment:
        return Payment(data: navProvider.screenData);
      case AppScreen.receipt:
        return Receipt(data: navProvider.screenData);
      case AppScreen.rating:
        return Rating(data: navProvider.screenData);
      case AppScreen.privateChat:
        return PrivateChat(data: navProvider.screenData);
      case AppScreen.profile:
        return const ProfileEdit();
    }
  }

  void _handleNavbarTap(BuildContext context, int index) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);

    switch (index) {
      case 0:
        navProvider.navigateTo(AppScreen.search, addToHistory: false);
        break;
      case 1:
        navProvider.navigateTo(AppScreen.tickets, addToHistory: false);
        break;
      case 2:
        navProvider.navigateTo(AppScreen.chat, addToHistory: false);
        break;
      case 3:
        navProvider.navigateTo(AppScreen.menu, addToHistory: false);
        break;
    }
  }
}
