// Modelo para Motoristas (da coleção users do app de motoristas)
class DriverModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final String status;
  final DateTime? createdAt;

  DriverModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    required this.status,
    this.createdAt,
  });

  factory DriverModel.fromFirestore(Map<String, dynamic> data, String id) {
    return DriverModel(
      id: id,
      name: data['name'] ?? 'Motorista',
      email: data['email'] ?? '',
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      status: data['status'] ?? 'pendente',
      createdAt: data['createdAt']?.toDate(),
    );
  }
}
