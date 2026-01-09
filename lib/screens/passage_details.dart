import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/exports.dart';

class PassageDetails extends StatelessWidget {
  final Map<String, dynamic> data;

  const PassageDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final origin = data['origin'] ?? '';
    final destination = data['destination'] ?? '';
    final type = data['type'] ?? 'Veículo';
    final price = (data['price'] ?? 0.0).toDouble();
    final driverName = data['driverName'] ?? 'Motorista';
    final driverId = data['driverId'] ?? '';
    final driverRating = data['driverRating'] ?? '0.0';
    final driverTrips = data['driverTrips'] ?? 0;
    final routeId = data['routeId'] ?? '';
    final departureTime = data['departureTime'] ?? '07:00';

    return Container(
      color: AppColors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texto informativo
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Informações sobre a viagem e o motorista',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGray,
                ),
              ),
            ),

            // Card principal da viagem
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TripInfoCard(
                vehicleType: type,
                origin: origin,
                destination: destination,
                departureTime: departureTime,
                price: price,
              ),
            ),

            // Avaliações e Tags
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: RatingTagsSection(),
            ),

            const SizedBox(height: 16),

            // Informações do motorista
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DriverInfoCard(
                driverName: driverName,
                rating: driverRating.toString(),
                trips: driverTrips is int
                    ? driverTrips
                    : int.tryParse(driverTrips.toString()) ?? 0,
                onChatPressed: () => _openChat(context, driverName, driverId),
              ),
            ),

            const SizedBox(height: 16),

            // Contato com suporte
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SupportContactCard(),
            ),

            const SizedBox(height: 32),

            // Botão de compra
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryButton(
                label: 'Comprar Passagem',
                onPressed: () => _buyTicket(
                  context,
                  price: price,
                  origin: origin,
                  destination: destination,
                  vehicleType: type,
                  driverName: driverName,
                  driverId: driverId,
                  routeId: routeId,
                  departureTime: departureTime,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _openChat(BuildContext context, String driverName, String driverId) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    navProvider.navigateTo(
      AppScreen.privateChat,
      title: driverName,
      data: {'driverName': driverName, 'driverId': driverId},
    );
  }

  void _buyTicket(
    BuildContext context, {
    required double price,
    required String origin,
    required String destination,
    required String vehicleType,
    required String driverName,
    required String driverId,
    required String routeId,
    required String departureTime,
  }) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    navProvider.navigateTo(
      AppScreen.payment,
      data: {
        'ticketPrice': price,
        'origin': origin,
        'destination': destination,
        'vehicleType': vehicleType,
        'driverName': driverName,
        'driverId': driverId,
        'routeId': routeId,
        'departureTime': departureTime,
      },
    );
  }
}
