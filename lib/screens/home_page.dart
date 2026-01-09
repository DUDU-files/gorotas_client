import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/providers/navigation_provider.dart';
import 'package:vans/widgets/navbar.dart';
import 'package:vans/widgets/app_header.dart';
import 'package:vans/screens/contents/search_content.dart';
import 'package:vans/screens/contents/tickets_content.dart';
import 'package:vans/screens/contents/chat_content.dart';
import 'package:vans/screens/contents/menu_content.dart';
import 'package:vans/screens/contents/results_content.dart';
import 'package:vans/screens/contents/passage_details_content.dart';
import 'package:vans/screens/contents/payment_content.dart';
import 'package:vans/screens/contents/receipt_content.dart';
import 'package:vans/screens/contents/rating_content.dart';
import 'package:vans/screens/contents/private_chat_content.dart';
import 'package:vans/screens/contents/profile_content.dart';

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
        return const SearchContent();
      case AppScreen.tickets:
        return const TicketsContent();
      case AppScreen.chat:
        return const ChatContent();
      case AppScreen.menu:
        return const MenuContent();
      case AppScreen.results:
        return const ResultsContent();
      case AppScreen.passageDetails:
        return PassageDetailsContent(data: navProvider.screenData);
      case AppScreen.payment:
        return PaymentContent(data: navProvider.screenData);
      case AppScreen.receipt:
        return ReceiptContent(data: navProvider.screenData);
      case AppScreen.rating:
        return RatingContent(data: navProvider.screenData);
      case AppScreen.privateChat:
        return PrivateChatContent(data: navProvider.screenData);
      case AppScreen.profile:
        return const ProfileContent();
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
