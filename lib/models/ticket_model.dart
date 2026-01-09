// Modelo para Passagens/Tickets do usuário
class TicketModel {
  final String id;
  final String routeId;
  final String clientId; // ID do cliente (usuário)
  final String origin;
  final String destination;
  final String vehicleType;
  final double price;
  final String date;
  final String time;
  final String status; // 'pendente', 'concluida', 'cancelada'
  final bool hasRated;
  final int rating; // Avaliação de 1-5 estrelas
  final String? feedback; // Comentário opcional
  final String? driverName;
  final String? driverId; // ID do motorista para calcular média
  final String? seatNumber;
  final DateTime? createdAt;

  TicketModel({
    required this.id,
    required this.routeId,
    required this.clientId,
    required this.origin,
    required this.destination,
    required this.vehicleType,
    required this.price,
    required this.date,
    required this.time,
    required this.status,
    this.hasRated = false,
    this.rating = 0,
    this.feedback,
    this.driverName,
    this.driverId,
    this.seatNumber,
    this.createdAt,
  });

  factory TicketModel.fromFirestore(Map<String, dynamic> data, String id) {
    return TicketModel(
      id: id,
      routeId: data['routeId'] ?? '',
      clientId: data['clientId'] ?? '',
      origin: data['origin'] ?? '',
      destination: data['destination'] ?? '',
      vehicleType: data['vehicleType'] ?? 'Veículo',
      price: (data['price'] ?? 0).toDouble(),
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      status: data['status'] ?? 'pendente',
      hasRated: data['hasRated'] ?? false,
      rating: data['rating'] ?? 0,
      feedback: data['feedback'],
      driverName: data['driverName'],
      driverId: data['driverId'],
      seatNumber: data['seatNumber'],
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routeId': routeId,
      'clientId': clientId,
      'origin': origin,
      'destination': destination,
      'vehicleType': vehicleType,
      'price': price,
      'date': date,
      'time': time,
      'status': status,
      'hasRated': hasRated,
      'rating': rating,
      'feedback': feedback,
      'driverName': driverName,
      'driverId': driverId,
      'seatNumber': seatNumber,
    };
  }
}
