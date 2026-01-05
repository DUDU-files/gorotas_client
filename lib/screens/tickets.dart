import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/widgets/bottom_menu.dart';
import 'package:vans/widgets/trip_card.dart';
import 'package:vans/screens/rating.dart';
import 'package:vans/screens/receipt.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  int _selectedMenuIndex = 1;

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(
          origin: trip['origin'],
          destination: trip['destination'],
          type: trip['type'],
          price: 30.00,
          date: trip['date'],
          time: '07:00',
          passengerName: 'João Silva Santos',
          passengerId: '123.456.789-00',
          seatNumber: '12A',
        ),
      ),
    );
  }

  void _rateTrip(String tripType) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RatingScreen(tripType: tripType)),
    );
  }

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
              'Histórico de Viagens',
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
