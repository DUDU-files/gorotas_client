import 'package:flutter/material.dart';
import 'package:vans/models/route_model.dart';
import 'package:vans/models/driver_model.dart';
import 'package:vans/models/vehicle_model.dart';
import 'package:vans/services/route_service.dart';
import 'package:vans/services/ticket_service.dart';

class RouteProvider extends ChangeNotifier {
  final RouteService _routeService = RouteService();
  final TicketService _ticketService = TicketService();

  List<RouteModel> _routes = [];
  List<RouteModel> _filteredRoutes = [];
  bool _hasSearched = false; // Flag para saber se já fez uma busca
  Map<String, DriverModel> _driversCache = {};
  Map<String, VehicleModel> _vehiclesCache = {};
  Map<String, double> _ratingsCache = {}; // Cache de avaliações por rota
  bool _isLoading = false;
  String? _error;

  // Filtros atuais
  String? _currentOrigin;
  String? _currentDestination;
  DateTime? _selectedDate; // Data selecionada na busca
  List<String> _selectedTimeRanges = [];
  double _minPrice = 0;
  double _maxPrice = 1000;
  List<String> _selectedVehicleTypes = [];

  // Se já fez busca, retorna filteredRoutes (mesmo vazia), senão retorna todas
  List<RouteModel> get routes => _hasSearched ? _filteredRoutes : _routes;
  List<RouteModel> get allRoutes => _routes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get selectedDate => _selectedDate; // Getter para data selecionada
  bool get hasSearched => _hasSearched;

  // Getters para os filtros
  String? get currentOrigin => _currentOrigin;
  String? get currentDestination => _currentDestination;
  List<String> get selectedTimeRanges => _selectedTimeRanges;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  List<String> get selectedVehicleTypes => _selectedVehicleTypes;

  // Buscar todas as rotas
  Future<void> loadRoutes() async {
    _isLoading = true;
    _error = null;
    _filteredRoutes = [];
    _hasSearched = false; // Reset quando carrega todas as rotas
    notifyListeners();

    try {
      _routes = await _routeService.getRoutesWithOwnerNames();
      await _loadDriversAndVehicles();
      await _loadRouteRatings();
    } catch (e) {
      _error = 'Erro ao carregar viagens: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Buscar rotas com filtros de origem e destino
  Future<void> searchRoutes({
    String? origin,
    String? destination,
    String? date,
  }) async {
    _isLoading = true;
    _error = null;
    _currentOrigin = origin;
    _currentDestination = destination;
    _filteredRoutes = [];

    // Parsear a data se fornecida (formato dd/MM/yyyy)
    _selectedDate = null;
    if (date != null && date.isNotEmpty) {
      try {
        List<String> parts = date.split('/');
        if (parts.length == 3) {
          _selectedDate = DateTime(
            int.parse(parts[2]), // ano
            int.parse(parts[1]), // mês
            int.parse(parts[0]), // dia
          );
        }
      } catch (e) {
        print('Erro ao parsear data: $e');
      }
    }

    notifyListeners();

    try {
      // Buscar todas as rotas primeiro
      _routes = await _routeService.getRoutesWithOwnerNames();
      await _loadDriversAndVehicles();
      await _loadRouteRatings();

      // Filtrar localmente para busca parcial (contains)
      _hasSearched = true; // Marca que uma busca foi feita
      _filteredRoutes = _routes.where((route) {
        bool matchOrigin = true;
        bool matchDestination = true;
        bool matchDate = true;

        if (origin != null && origin.isNotEmpty) {
          matchOrigin = route.origin.toLowerCase().contains(
            origin.toLowerCase(),
          );
        }
        if (destination != null && destination.isNotEmpty) {
          matchDestination = route.destination.toLowerCase().contains(
            destination.toLowerCase(),
          );
        }

        // Filtrar por data/dia da semana
        if (_selectedDate != null) {
          matchDate = route.isAvailableOn(_selectedDate!);
        }

        return matchOrigin && matchDestination && matchDate;
      }).toList();

      // Ordenar por horário (primeiro timeSlot)
      _filteredRoutes.sort((a, b) {
        final timeA = _getFirstTimeSlotMinutes(a.timeSlots);
        final timeB = _getFirstTimeSlotMinutes(b.timeSlots);
        return timeA.compareTo(timeB);
      });
    } catch (e) {
      _error = 'Erro ao buscar viagens: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Aplicar filtros adicionais (horário, preço, tipo de veículo)
  void applyFilters({
    List<String>? timeRanges,
    double? minPrice,
    double? maxPrice,
    List<String>? vehicleTypes,
  }) {
    _selectedTimeRanges = timeRanges ?? [];
    _minPrice = minPrice ?? 0;
    _maxPrice = maxPrice ?? 1000;
    _selectedVehicleTypes = vehicleTypes ?? [];
    _hasSearched = true; // Marca que uma busca/filtro foi aplicado

    // Aplicar filtros na lista de rotas
    List<RouteModel> baseRoutes = _routes;

    _filteredRoutes = baseRoutes.where((route) {
      // Filtro de origem/destino (se já aplicado)
      bool matchOrigin = true;
      bool matchDestination = true;
      if (_currentOrigin != null && _currentOrigin!.isNotEmpty) {
        matchOrigin = route.origin.toLowerCase().contains(
          _currentOrigin!.toLowerCase(),
        );
      }
      if (_currentDestination != null && _currentDestination!.isNotEmpty) {
        matchDestination = route.destination.toLowerCase().contains(
          _currentDestination!.toLowerCase(),
        );
      }

      // Filtro de data/dia da semana
      bool matchDate = true;
      if (_selectedDate != null) {
        matchDate = route.isAvailableOn(_selectedDate!);
      }

      // Filtro de preço
      bool matchPrice = route.price >= _minPrice && route.price <= _maxPrice;

      // Filtro de horário
      bool matchTime = true;
      if (_selectedTimeRanges.isNotEmpty) {
        matchTime = route.timeSlots.any(
          (slot) => _isTimeInRanges(slot, _selectedTimeRanges),
        );
      }

      // Filtro de tipo de veículo
      bool matchVehicleType = true;
      if (_selectedVehicleTypes.isNotEmpty) {
        String vehicleType = getVehicleType(route);
        matchVehicleType = _selectedVehicleTypes.any(
          (type) => vehicleType.toLowerCase().contains(type.toLowerCase()),
        );
      }

      return matchOrigin &&
          matchDestination &&
          matchDate &&
          matchPrice &&
          matchTime &&
          matchVehicleType;
    }).toList();

    // Ordenar por horário (primeiro timeSlot)
    _filteredRoutes.sort((a, b) {
      final timeA = _getFirstTimeSlotMinutes(a.timeSlots);
      final timeB = _getFirstTimeSlotMinutes(b.timeSlots);
      return timeA.compareTo(timeB);
    });

    notifyListeners();
  }

  // Converte o primeiro timeSlot em minutos para ordenação
  int _getFirstTimeSlotMinutes(List<String> timeSlots) {
    if (timeSlots.isEmpty) return 9999; // Sem horário vai para o final
    try {
      final parts = timeSlots.first.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
      return hour * 60 + minute;
    } catch (e) {
      return 9999;
    }
  }

  // Verifica se um horário está dentro dos ranges selecionados
  bool _isTimeInRanges(String timeSlot, List<String> ranges) {
    try {
      // Extrai hora do slot (formato "HH:MM")
      int hour = int.parse(timeSlot.split(':')[0]);

      for (String range in ranges) {
        if (range == '06:00 - 11:59' && hour >= 6 && hour < 12) return true;
        if (range == '12:00 - 17:59' && hour >= 12 && hour < 18) return true;
        if (range == '18:00 - 23:59' && hour >= 18 && hour < 24) return true;
        if (range == '00:00 - 05:59' && hour >= 0 && hour < 6) return true;
      }
      return false;
    } catch (e) {
      return true; // Se não conseguir parsear, inclui na lista
    }
  }

  // Limpar filtros e recarregar
  void clearFilters() {
    _currentOrigin = null;
    _currentDestination = null;
    _selectedDate = null;
    _selectedTimeRanges = [];
    _minPrice = 0;
    _maxPrice = 1000;
    _selectedVehicleTypes = [];
    _filteredRoutes = [];
    _hasSearched = false; // Reset quando limpa filtros
    notifyListeners();
  }

  // Carregar motoristas e veículos das rotas
  Future<void> _loadDriversAndVehicles() async {
    for (var route in _routes) {
      if (!_driversCache.containsKey(route.ownerId) &&
          route.ownerId.isNotEmpty) {
        DriverModel? driver = await _routeService.getDriver(route.ownerId);
        if (driver != null) {
          _driversCache[route.ownerId] = driver;
        }
      }

      if (!_vehiclesCache.containsKey(route.ownerId) &&
          route.ownerId.isNotEmpty) {
        VehicleModel? vehicle = await _routeService.getVehicleByOwner(
          route.ownerId,
        );
        if (vehicle != null) {
          _vehiclesCache[route.ownerId] = vehicle;
        }
      }
    }
  }

  // Carregar avaliações médias das rotas
  Future<void> _loadRouteRatings() async {
    for (var route in _routes) {
      if (!_ratingsCache.containsKey(route.id)) {
        double rating = await _ticketService.getRouteAverageRating(route.id);
        _ratingsCache[route.id] = rating;
      }
    }
  }

  // Obter motorista de uma rota
  DriverModel? getDriverForRoute(RouteModel route) {
    return _driversCache[route.ownerId];
  }

  // Obter veículo de uma rota
  VehicleModel? getVehicleForRoute(RouteModel route) {
    return _vehiclesCache[route.ownerId];
  }

  // Obter tipo de veículo para uma rota
  String getVehicleType(RouteModel route) {
    final vehicle = _vehiclesCache[route.ownerId];
    if (vehicle == null) return 'Veículo';
    final type = vehicle.type;
    return type.isNotEmpty ? type : 'Veículo';
  }

  // Obter nome do veículo (marca modelo)
  String getVehicleName(RouteModel route) {
    return _vehiclesCache[route.ownerId]?.fullName ?? '';
  }

  // Obter nome do motorista para uma rota
  String getDriverName(RouteModel route) {
    if (route.ownerName.isNotEmpty && route.ownerName != 'Motorista') {
      return route.ownerName;
    }
    return _driversCache[route.ownerId]?.name ?? 'Motorista';
  }

  // Obter avaliação média de uma rota
  double getRouteRating(RouteModel route) {
    return _ratingsCache[route.id] ?? 0.0;
  }

  // Obter ID do motorista de uma rota
  String getDriverId(RouteModel route) {
    return route.ownerId;
  }
}
