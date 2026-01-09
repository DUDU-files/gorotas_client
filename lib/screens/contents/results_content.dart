import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/widgets/passage_card.dart';
import 'package:vans/widgets/filter.dart';
import 'package:vans/widgets/app_card.dart';
import 'package:vans/providers/navigation_provider.dart';
import 'package:vans/providers/route_provider.dart';

class ResultsContent extends StatefulWidget {
  const ResultsContent({super.key});

  @override
  State<ResultsContent> createState() => _ResultsContentState();
}

class _ResultsContentState extends State<ResultsContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RouteProvider>(context, listen: false).loadRoutes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(
      builder: (context, routeProvider, child) {
        if (routeProvider.isLoading) {
          return const LoadingIndicator();
        }

        if (routeProvider.error != null) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Erro ao carregar viagens',
            subtitle: routeProvider.error,
            onRetry: () => routeProvider.loadRoutes(),
          );
        }

        if (routeProvider.routes.isEmpty) {
          return const EmptyState(
            icon: Icons.directions_bus_outlined,
            title: 'Nenhuma viagem disponível',
            subtitle: 'Tente buscar por outra rota',
          );
        }

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 80),
              itemCount: routeProvider.routes.length,
              itemBuilder: (context, index) {
                final route = routeProvider.routes[index];
                final vehicleType = routeProvider.getVehicleType(route);
                final vehicleName = routeProvider.getVehicleName(route);
                final driverName = routeProvider.getDriverName(route);
                final driverId = routeProvider.getDriverId(route);
                final rating = routeProvider.getRouteRating(route);

                // Se há uma data específica pesquisada, mostra só ela
                // Caso contrário, mostra as próximas datas disponíveis
                final selectedDate = routeProvider.selectedDate;
                List<String> availableDates;
                String displayDate;

                if (selectedDate != null) {
                  // Mostra apenas a data pesquisada
                  displayDate =
                      '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}';
                  availableDates = [displayDate];
                } else {
                  // Mostra as próximas datas disponíveis
                  availableDates = route.getNextAvailableDatesFormatted(
                    count: 5,
                  );
                  displayDate = availableDates.isNotEmpty
                      ? availableDates.first
                      : 'Diário';
                }

                return PassageCard(
                  origin: route.origin,
                  destination: route.destination,
                  type: vehicleType,
                  price: route.price,
                  date: displayDate,
                  availableSeats: route.availableSeats,
                  duration: route.duration,
                  departureTime: route.departureTime,
                  availableTimes: route.timeSlots,
                  availableDates: availableDates,
                  rating: rating,
                  onMoreInfo: () => _showDetails(
                    route,
                    vehicleType,
                    vehicleName,
                    driverName,
                    driverId,
                  ),
                  onBuyTicket: () => _buyTicket(
                    route,
                    vehicleType,
                    driverName,
                    driverId,
                    route.departureTime,
                  ),
                );
              },
            ),
            Positioned(
              right: 16,
              bottom: 80,
              child: FloatingActionButton(
                backgroundColor: AppColors.primaryOrange,
                onPressed: () => _showFilters(context),
                child: const Icon(Icons.tune, color: AppColors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDetails(
    route,
    String vehicleType,
    String vehicleName,
    String driverName,
    String driverId,
  ) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    navProvider.navigateTo(
      AppScreen.passageDetails,
      data: {
        'origin': route.origin,
        'destination': route.destination,
        'type': vehicleType,
        'price': route.price,
        'date': 'Diário',
        'departureTime': route.departureTime,
        'timeSlots': route.timeSlots,
        'duration': route.duration,
        'availableSeats': route.availableSeats,
        'driverName': driverName,
        'driverId': driverId,
        'vehicleName': vehicleName,
        'routeId': route.id,
      },
    );
  }

  void _buyTicket(
    route,
    String vehicleType,
    String driverName,
    String driverId,
    String departureTime,
  ) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    navProvider.navigateTo(
      AppScreen.payment,
      data: {
        'ticketPrice': route.price,
        'routeId': route.id,
        'origin': route.origin,
        'destination': route.destination,
        'vehicleType': vehicleType,
        'driverName': driverName,
        'driverId': driverId,
        'departureTime': departureTime,
      },
    );
  }

  void _showFilters(BuildContext context) {
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
  }
}
