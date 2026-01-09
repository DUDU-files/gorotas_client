import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/widgets/trip_card.dart';
import 'package:vans/widgets/app_card.dart';
import 'package:vans/providers/navigation_provider.dart';
import 'package:vans/providers/ticket_provider.dart';
import 'package:vans/providers/user_provider.dart';

class TicketsContent extends StatefulWidget {
  const TicketsContent({super.key});

  @override
  State<TicketsContent> createState() => _TicketsContentState();
}

class _TicketsContentState extends State<TicketsContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTickets();
    });
  }

  void _loadTickets() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);

    if (userProvider.userId != null) {
      ticketProvider.loadTickets(userProvider.userId!);
    }
  }

  void _downloadReceipt(Map<String, dynamic> ticketData) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    navProvider.navigateTo(AppScreen.receipt, data: ticketData);
  }

  void _rateTrip(String ticketId) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    navProvider.navigateTo(AppScreen.rating, data: {'ticketId': ticketId});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketProvider>(
      builder: (context, ticketProvider, child) {
        if (ticketProvider.isLoading) {
          return const LoadingIndicator();
        }

        if (ticketProvider.error != null) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Erro ao carregar passagens',
            subtitle: ticketProvider.error,
            onRetry: _loadTickets,
          );
        }

        if (ticketProvider.tickets.isEmpty) {
          return const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Nenhuma passagem encontrada',
            subtitle: 'Suas viagens aparecerão aqui',
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
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
                      '${ticketProvider.tickets.length} viagens',
                      style: const TextStyle(
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
                itemCount: ticketProvider.tickets.length,
                itemBuilder: (context, index) {
                  final ticket = ticketProvider.tickets[index];
                  return TripCard(
                    type: ticket.vehicleType,
                    date: ticket.date,
                    origin: ticket.origin,
                    destination: ticket.destination,
                    rating: ticket.rating.toDouble(),
                    onDownload: () => _downloadReceipt({
                      'origin': ticket.origin,
                      'destination': ticket.destination,
                      'type': ticket.vehicleType,
                      'price': ticket.price,
                      'date': ticket.date,
                      'time': ticket.time,
                      'driverName': ticket.driverName ?? 'Motorista',
                      'seatNumber': ticket.seatNumber ?? '-',
                    }),
                    onRating: ticket.hasRated
                        ? null
                        : () => _rateTrip(ticket.id),
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }
}
