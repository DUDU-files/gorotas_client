import 'package:flutter/material.dart';
import 'package:vans/models/ticket_model.dart';
import 'package:vans/services/ticket_service.dart';

class TicketProvider extends ChangeNotifier {
  final TicketService _ticketService = TicketService();

  List<TicketModel> _tickets = [];
  bool _isLoading = false;
  String? _error;
  String? _currentClientId;

  List<TicketModel> get tickets => _tickets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Carregar tickets do usuário
  Future<void> loadTickets(String clientId) async {
    _isLoading = true;
    _error = null;
    _currentClientId = clientId;
    notifyListeners();

    try {
      _tickets = await _ticketService.getUserTickets(clientId);
    } catch (e) {
      _error = 'Erro ao carregar passagens: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Criar novo ticket
  Future<TicketModel?> buyTicket({
    required String routeId,
    required String clientId,
    required String origin,
    required String destination,
    required String vehicleType,
    required double price,
    required String date,
    required String time,
    String? driverName,
    String? driverId,
    String? seatNumber,
  }) async {
    try {
      final ticket = await _ticketService.createTicket(
        routeId: routeId,
        clientId: clientId,
        origin: origin,
        destination: destination,
        vehicleType: vehicleType,
        price: price,
        date: date,
        time: time,
        driverName: driverName,
        driverId: driverId,
        seatNumber: seatNumber,
      );

      if (ticket != null) {
        _tickets.insert(0, ticket);
        notifyListeners();
      }

      return ticket;
    } catch (e) {
      _error = 'Erro ao comprar passagem: $e';
      notifyListeners();
      return null;
    }
  }

  // Avaliar ticket
  Future<bool> rateTicket({
    required String ticketId,
    required int rating,
    String? feedback,
  }) async {
    final success = await _ticketService.rateTicket(
      ticketId: ticketId,
      rating: rating,
      feedback: feedback,
    );

    if (success && _currentClientId != null) {
      // Recarregar tickets para atualizar a lista
      await loadTickets(_currentClientId!);
    }

    return success;
  }

  // Obter média de avaliação de um motorista
  Future<double> getDriverRating(String driverId) async {
    return await _ticketService.getDriverAverageRating(driverId);
  }

  // Obter média de avaliação de uma rota
  Future<double> getRouteRating(String routeId) async {
    return await _ticketService.getRouteAverageRating(routeId);
  }

  // Marcar como avaliado (legado)
  Future<void> markAsRated(String ticketId) async {
    await _ticketService.markAsRated(ticketId);

    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final clientId = _tickets[index].clientId;
      await loadTickets(clientId);
    }
  }
}
