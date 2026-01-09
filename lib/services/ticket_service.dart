import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vans/models/ticket_model.dart';

class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Buscar tickets do usuário
  Future<List<TicketModel>> getUserTickets(String clientId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tickets')
          .where('clientId', isEqualTo: clientId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return TicketModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print('Erro ao buscar tickets: $e');
      return [];
    }
  }

  // Criar novo ticket (comprar passagem)
  Future<TicketModel?> createTicket({
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
      final docRef = await _firestore.collection('tickets').add({
        'routeId': routeId,
        'clientId': clientId,
        'origin': origin,
        'destination': destination,
        'vehicleType': vehicleType,
        'price': price,
        'date': date,
        'time': time,
        'status': 'pendente',
        'hasRated': false,
        'rating': 0,
        'driverName': driverName,
        'driverId': driverId,
        'seatNumber': seatNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final doc = await docRef.get();
      return TicketModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    } catch (e) {
      print('Erro ao criar ticket: $e');
      return null;
    }
  }

  // Salvar avaliação do ticket
  Future<bool> rateTicket({
    required String ticketId,
    required int rating,
    String? feedback,
  }) async {
    try {
      await _firestore.collection('tickets').doc(ticketId).update({
        'hasRated': true,
        'rating': rating,
        'feedback': feedback,
      });
      return true;
    } catch (e) {
      print('Erro ao avaliar ticket: $e');
      return false;
    }
  }

  // Calcular média de avaliações por motorista (driverId)
  Future<double> getDriverAverageRating(String driverId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tickets')
          .where('driverId', isEqualTo: driverId)
          .where('hasRated', isEqualTo: true)
          .get();

      if (snapshot.docs.isEmpty) return 0.0;

      int totalRating = 0;
      int count = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final rating = data['rating'] ?? 0;
        if (rating > 0) {
          totalRating += rating as int;
          count++;
        }
      }

      if (count == 0) return 0.0;
      return totalRating / count;
    } catch (e) {
      print('Erro ao calcular média: $e');
      return 0.0;
    }
  }

  // Calcular média de avaliações por rota
  Future<double> getRouteAverageRating(String routeId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tickets')
          .where('routeId', isEqualTo: routeId)
          .where('hasRated', isEqualTo: true)
          .get();

      if (snapshot.docs.isEmpty) return 0.0;

      int totalRating = 0;
      int count = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final rating = data['rating'] ?? 0;
        if (rating > 0) {
          totalRating += rating as int;
          count++;
        }
      }

      if (count == 0) return 0.0;
      return totalRating / count;
    } catch (e) {
      print('Erro ao calcular média da rota: $e');
      return 0.0;
    }
  }

  // Marcar ticket como avaliado
  Future<void> markAsRated(String ticketId) async {
    try {
      await _firestore.collection('tickets').doc(ticketId).update({
        'hasRated': true,
      });
    } catch (e) {
      print('Erro ao marcar como avaliado: $e');
    }
  }

  // Atualizar status do ticket
  Future<void> updateStatus(String ticketId, String status) async {
    try {
      await _firestore.collection('tickets').doc(ticketId).update({
        'status': status,
      });
    } catch (e) {
      print('Erro ao atualizar status: $e');
    }
  }

  // Stream de tickets em tempo real
  Stream<List<TicketModel>> getTicketsStream(String clientId) {
    return _firestore
        .collection('tickets')
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TicketModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }
}
