// Modelo para Veículos
class VehicleModel {
  final String id;
  final String brand; // Marca (chevrolet)
  final String model; // Modelo (Celta)
  final String plate; // Placa
  final int seats; // Capacidade de passageiros
  final int year;
  final int mileage;
  final String ownerId;
  final String status;
  final String type; // Tipo do veículo (Van, Lotação)
  final List<String> amenities;
  final DateTime? createdAt;
  final DateTime? lastReview;

  VehicleModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.plate,
    required this.seats,
    required this.year,
    required this.mileage,
    required this.ownerId,
    required this.status,
    required this.type,
    required this.amenities,
    this.createdAt,
    this.lastReview,
  });

  factory VehicleModel.fromFirestore(Map<String, dynamic> data, String id) {
    List<String> amenitiesList = [];
    if (data['amenities'] != null) {
      if (data['amenities'] is List) {
        amenitiesList = List<String>.from(data['amenities']);
      }
    }

    return VehicleModel(
      id: id,
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      plate: data['plate'] ?? '',
      seats: (data['seats'] ?? 0).toInt(),
      year: (data['year'] ?? 0).toInt(),
      mileage: (data['mileage'] ?? 0).toInt(),
      ownerId: data['ownerId'] ?? '',
      status: data['status'] ?? 'Ativo',
      type: data['type'] ?? 'Veículo',
      amenities: amenitiesList,
      createdAt: data['createdAt']?.toDate(),
      lastReview: data['lastReview']?.toDate(),
    );
  }

  // Retorna nome completo do veículo
  String get fullName => '$brand $model'.trim();
}
