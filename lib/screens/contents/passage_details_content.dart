import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/providers/navigation_provider.dart';
import 'package:vans/widgets/app_card.dart';

class PassageDetailsContent extends StatelessWidget {
  final Map<String, dynamic> data;

  const PassageDetailsContent({super.key, required this.data});

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
              child: _buildTripCard(
                type,
                origin,
                destination,
                departureTime,
                price,
              ),
            ),

            // Avaliações e Tags
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildRatingAndTagsSection(),
            ),

            const SizedBox(height: 16),

            // Informações do motorista
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildDriverSection(
                context,
                driverName: driverName,
                driverId: driverId,
                rating: driverRating.toString(),
                trips: driverTrips is int
                    ? driverTrips
                    : int.tryParse(driverTrips.toString()) ?? 0,
              ),
            ),

            const SizedBox(height: 16),

            // Contato com suporte
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSupportSection(),
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

  Widget _buildTripCard(
    String type,
    String origin,
    String destination,
    String departureTime,
    double price,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Tipo do veículo e preço
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    type == 'Van'
                        ? Icons.airport_shuttle
                        : Icons.directions_car,
                    size: 20,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              Text(
                'R\$ ${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Trajeto visual
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryBlue,
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    color: AppColors.primaryBlue.withOpacity(0.3),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      origin,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      destination,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Horário
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.lightGray.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.access_time,
                  size: 18,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Horário de saída: ',
                  style: TextStyle(fontSize: 13, color: AppColors.primaryGray),
                ),
                Text(
                  departureTime,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingAndTagsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estrelas
          Row(
            children: List.generate(
              5,
              (index) => const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.star, color: AppColors.starFilled, size: 20),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              InfoTag(label: 'Boa rota'),
              InfoTag(label: 'Equipamentos em boas condições'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverSection(
    BuildContext context, {
    required String driverName,
    required String driverId,
    required String rating,
    required int trips,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Foto do motorista
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.primaryGray,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          // Info do motorista
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 14,
                      color: AppColors.starFilled,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$rating · $trips+ viagens',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Botão de chat
          GestureDetector(
            onTap: () => _openChat(context, driverName, driverId),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.support_agent,
              color: AppColors.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Entrar em contato com suporte',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.primaryGray,
          ),
        ],
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
