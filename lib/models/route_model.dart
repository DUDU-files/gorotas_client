// Modelo para Rotas/Viagens
class RouteModel {
  final String id;
  final String origin;
  final String destination;
  final String duration;
  final double price;
  final int availableSeats;
  final int capacity;
  final String ownerId; // ID do motorista
  final String ownerName; // Nome do motorista (dono da rota)
  final String status;
  final List<String> timeSlots; // Horários disponíveis
  final List<String> weekDays; // Dias da semana que o motorista viaja
  final int tripsPerWeek;
  final DateTime? createdAt;

  RouteModel({
    required this.id,
    required this.origin,
    required this.destination,
    required this.duration,
    required this.price,
    required this.availableSeats,
    required this.capacity,
    required this.ownerId,
    this.ownerName = 'Motorista',
    required this.status,
    required this.timeSlots,
    this.weekDays = const [],
    required this.tripsPerWeek,
    this.createdAt,
  });

  factory RouteModel.fromFirestore(Map<String, dynamic> data, String id) {
    // Converter timeSlots para List<String>
    List<String> slots = [];
    if (data['timeSlots'] != null) {
      slots = List<String>.from(data['timeSlots']);
    }

    // Converter weekDays para List<String>
    List<String> days = [];
    if (data['weekDays'] != null) {
      days = List<String>.from(data['weekDays']);
    }

    return RouteModel(
      id: id,
      origin: data['origin'] ?? '',
      destination: data['destination'] ?? '',
      duration: data['duration'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      availableSeats: data['availableSeats'] ?? 0,
      capacity: data['capacity'] ?? 0,
      ownerId: data['ownerId'] ?? '',
      ownerName: data['ownerName'] ?? 'Motorista',
      status: data['status'] ?? 'Ativa',
      timeSlots: slots,
      weekDays: days,
      tripsPerWeek: data['tripsPerWeek'] ?? 0,
      createdAt: data['createdAt']?.toDate(),
    );
  }

  // Retorna o primeiro horário disponível
  String get departureTime => timeSlots.isNotEmpty ? timeSlots.first : '00:00';

  // Mapeamento de dias da semana em português para número (DateTime.weekday)
  static const Map<String, int> _weekDayMap = {
    // Nomes completos
    'segunda': DateTime.monday, // 1
    'terça': DateTime.tuesday, // 2
    'terca': DateTime.tuesday, // 2 (sem acento)
    'quarta': DateTime.wednesday, // 3
    'quinta': DateTime.thursday, // 4
    'sexta': DateTime.friday, // 5
    'sábado': DateTime.saturday, // 6
    'sabado': DateTime.saturday, // 6 (sem acento)
    'domingo': DateTime.sunday, // 7
    // Abreviações
    'seg': DateTime.monday, // 1
    'ter': DateTime.tuesday, // 2
    'qua': DateTime.wednesday, // 3
    'qui': DateTime.thursday, // 4
    'sex': DateTime.friday, // 5
    'sab': DateTime.saturday, // 6
    'sáb': DateTime.saturday, // 6
    'dom': DateTime.sunday, // 7
  };

  // Converte o nome do dia para número do DateTime.weekday
  int? _dayNameToWeekday(String dayName) {
    return _weekDayMap[dayName.toLowerCase().trim()];
  }

  // Retorna as próximas N datas disponíveis baseado nos dias da semana
  List<DateTime> getNextAvailableDates({int count = 7}) {
    if (weekDays.isEmpty) return [];

    final List<DateTime> availableDates = [];
    final now = DateTime.now();
    var checkDate = DateTime(now.year, now.month, now.day);

    // Converte os dias da semana cadastrados para números
    final availableWeekdays = weekDays
        .map((day) => _dayNameToWeekday(day))
        .where((d) => d != null)
        .cast<int>()
        .toSet();

    if (availableWeekdays.isEmpty) return [];

    // Procura as próximas datas disponíveis
    int daysChecked = 0;
    while (availableDates.length < count && daysChecked < 60) {
      if (availableWeekdays.contains(checkDate.weekday)) {
        availableDates.add(checkDate);
      }
      checkDate = checkDate.add(const Duration(days: 1));
      daysChecked++;
    }

    return availableDates;
  }

  // Retorna as próximas datas formatadas como "dia/mês"
  List<String> getNextAvailableDatesFormatted({int count = 7}) {
    return getNextAvailableDates(count: count)
        .map(
          (date) =>
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}',
        )
        .toList();
  }

  // Retorna apenas os dias (números) das próximas viagens
  List<int> getNextAvailableDays({int count = 7}) {
    return getNextAvailableDates(count: count).map((date) => date.day).toList();
  }

  // Verifica se a rota está disponível em uma data específica
  bool isAvailableOn(DateTime date) {
    // Se não há dias cadastrados, não mostra a rota quando há filtro de data
    if (weekDays.isEmpty) return false;

    final availableWeekdays = weekDays
        .map((day) => _dayNameToWeekday(day))
        .where((d) => d != null)
        .cast<int>()
        .toSet();

    // Se não conseguiu mapear nenhum dia, não mostra
    if (availableWeekdays.isEmpty) return false;

    return availableWeekdays.contains(date.weekday);
  }

  Map<String, dynamic> toMap() {
    return {
      'origin': origin,
      'destination': destination,
      'duration': duration,
      'price': price,
      'availableSeats': availableSeats,
      'capacity': capacity,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'status': status,
      'timeSlots': timeSlots,
      'weekDays': weekDays,
      'tripsPerWeek': tripsPerWeek,
    };
  }
}
