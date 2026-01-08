import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/widgets/passage_card.dart';
import 'package:vans/widgets/filter.dart';
import 'package:vans/providers/navigation_provider.dart';

class ResultsContent extends StatefulWidget {
  const ResultsContent({super.key});

  @override
  State<ResultsContent> createState() => _ResultsContentState();
}

class _ResultsContentState extends State<ResultsContent> {
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
    return Stack(
      children: [
        SingleChildScrollView(
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
                    availableTimes: List<String>.from(
                      passage['availableTimes'],
                    ),
                    rating: passage['rating'],
                    onMoreInfo: () {
                      final navProvider = Provider.of<NavigationProvider>(
                        context,
                        listen: false,
                      );
                      navProvider.navigateTo(
                        AppScreen.passageDetails,
                        data: {
                          'origin': passage['origin'],
                          'destination': passage['destination'],
                          'type': passage['type'],
                          'price': passage['price'],
                          'date': passage['date'],
                          'departureTime': passage['departureTime'],
                          'rating': passage['rating'],
                          'driverName': 'Claudio',
                          'driverRating': '4.8',
                          'driverTrips': 100,
                        },
                      );
                    },
                    onBuyTicket: () {
                      final navProvider = Provider.of<NavigationProvider>(
                        context,
                        listen: false,
                      );
                      navProvider.navigateTo(
                        AppScreen.payment,
                        data: {'ticketPrice': passage['price']},
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 80,
          child: FloatingActionButton(
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
        ),
      ],
    );
  }
}
