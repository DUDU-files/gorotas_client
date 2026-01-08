import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/widgets/trip_card.dart';
import 'package:vans/providers/navigation_provider.dart';

class TicketsContent extends StatefulWidget {
  const TicketsContent({super.key});

  @override
  State<TicketsContent> createState() => _TicketsContentState();
}

class _TicketsContentState extends State<TicketsContent> {
  // Dados de exemplo para as viagens
  final List<Map<String, dynamic>> trips = [
    {
      'type': 'Van',
      'date': '01/02/2025',
      'origin': 'Caxias - MA',
      'destination': 'São Luís',
      'rating': 3,
      'status': 'Recibo',
    },
    {
      'type': 'Carro',
      'date': '01/02/2025',
      'origin': 'Caxias - MA',
      'destination': 'São Luís',
      'rating': 3,
      'status': 'Normal',
    },
    {
      'type': 'Van',
      'date': '01/02/2025',
      'origin': 'Caxias - MA',
      'destination': 'São Luís',
      'rating': 3,
      'status': 'Avaliação',
    },
  ];

  void _downloadPDF(String tripType, int index) {
    final trip = trips[index];
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    navProvider.navigateTo(
      AppScreen.receipt,
      data: {
        'origin': trip['origin'],
        'destination': trip['destination'],
        'type': trip['type'],
        'price': 30.00,
        'date': trip['date'],
        'time': '07:00',
        'passengerName': 'João Silva Santos',
        'passengerId': '123.456.789-00',
        'seatNumber': '12A',
      },
    );
  }

  void _rateTrip(String tripType) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    navProvider.navigateTo(AppScreen.rating, data: {'tripType': tripType});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Seção "Minhas Viagens"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Minhas Viagens',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  'Recibo',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Lista de viagens
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return TripCard(
                type: trip['type'],
                date: trip['date'],
                origin: trip['origin'],
                destination: trip['destination'],
                rating: trip['rating'].toDouble(),
                onDownload: () => _downloadPDF(trip['type'], index),
                onRating: () => _rateTrip(trip['type']),
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
