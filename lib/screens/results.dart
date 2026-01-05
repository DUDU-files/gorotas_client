import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/widgets/bottom_menu.dart';
import 'package:vans/widgets/passage_card.dart';
import 'package:vans/widgets/filter.dart';
import 'package:vans/screens/passage_details.dart';
import 'package:vans/screens/payment.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int _selectedMenuIndex = 0;

  // Dados de exemplo para as passagens
  final List<Map<String, dynamic>> passages = [
    {
      'origin': 'Caxias',
      'destination': 'Teresina',
      'type': 'Van',
      'price': 30.00,
      'date': '04/10/2025',
      'availableSeats': 11,
      'duration': '1h 10min',
      'departureTime': '07:00',
      'availableTimes': ['07:00'],
      'rating': 8.2,
    },
    {
      'origin': 'Caxias',
      'destination': 'São João do Sóter',
      'type': 'Lotação',
      'price': 40.00,
      'date': '04/10/2025',
      'availableSeats': 4,
      'duration': '50min',
      'departureTime': '07:30',
      'availableTimes': ['07:30'],
      'rating': 8.2,
    },
    {
      'origin': 'Caxias',
      'destination': 'Aldeias Altas',
      'type': 'Van',
      'price': 20.00,
      'date': '04/10/2025',
      'availableSeats': 2,
      'duration': '40min',
      'departureTime': '13:00',
      'availableTimes': ['13:00'],
      'rating': 8.2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.directions_bus,
                      size: 24,
                      color: AppColors.primaryBlue,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Resultado da Busca',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: passages.length,
              itemBuilder: (context, index) {
                final passage = passages[index];
                return PassageCard(
                  origin: passage['origin'],
                  destination: passage['destination'],
                  type: passage['type'],
                  price: passage['price'],
                  date: passage['date'],
                  availableSeats: passage['availableSeats'],
                  duration: passage['duration'],
                  departureTime: passage['departureTime'],
                  availableTimes: List<String>.from(passage['availableTimes']),
                  rating: passage['rating'],
                  onMoreInfo: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassageDetailsScreen(
                          origin: passage['origin'],
                          destination: passage['destination'],
                          type: passage['type'],
                          price: passage['price'],
                          date: passage['date'],
                          departureTime: passage['departureTime'],
                          rating: passage['rating'],
                          driverName: 'Claudio',
                          driverRating: '4.8',
                          driverTrips: 100,
                        ),
                      ),
                    );
                  },
                  onBuyTicket: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PaymentScreen(ticketPrice: passage['price']),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryOrange,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const FiltersModal(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.tune, color: AppColors.white),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedMenuIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedMenuIndex = index;
          });
        },
      ),
    );
  }
}
