import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vans/models/route_model.dart';
import 'package:vans/models/driver_model.dart';
import 'package:vans/models/vehicle_model.dart';

class RouteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Buscar todas as rotas disponíveis (apenas ativas)
  Future<List<RouteModel>> getAvailableRoutes() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('routes')
          .where('status', isEqualTo: 'Ativa')
          .get();

      return snapshot.docs.map((doc) {
        return RouteModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print('Erro ao buscar rotas: $e');
      return [];
    }
  }

  // Buscar rotas com filtros (origem, destino)
  Future<List<RouteModel>> searchRoutes({
    String? origin,
    String? destination,
  }) async {
    try {
      Query query = _firestore
          .collection('routes')
          .where('status', isEqualTo: 'Ativa');

      // Aplicar filtros se fornecidos
      if (origin != null && origin.isNotEmpty) {
        query = query.where('origin', isEqualTo: origin);
      }
      if (destination != null && destination.isNotEmpty) {
        query = query.where('destination', isEqualTo: destination);
      }

      QuerySnapshot snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return RouteModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print('Erro ao buscar rotas: $e');
      return [];
    }
  }

  // Buscar informações do motorista pelo ownerId
  Future<DriverModel?> getDriver(String ownerId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(ownerId)
          .get();

      if (doc.exists) {
        return DriverModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      print('Erro ao buscar motorista: $e');
      return null;
    }
  }

  // Buscar veículo pelo ownerId (motorista)
  Future<VehicleModel?> getVehicleByOwner(String ownerId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('vehicles')
          .where('ownerId', isEqualTo: ownerId)
          .where('status', isEqualTo: 'Ativo')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return VehicleModel.fromFirestore(
          snapshot.docs.first.data() as Map<String, dynamic>,
          snapshot.docs.first.id,
        );
      }
      return null;
    } catch (e) {
      print('Erro ao buscar veículo: $e');
      return null;
    }
  }

  // Buscar rota completa com informações do motorista e veículo
  Future<Map<String, dynamic>?> getCompleteRouteInfo(String routeId) async {
    try {
      DocumentSnapshot routeDoc = await _firestore
          .collection('routes')
          .doc(routeId)
          .get();

      if (!routeDoc.exists) return null;

      RouteModel route = RouteModel.fromFirestore(
        routeDoc.data() as Map<String, dynamic>,
        routeDoc.id,
      );

      DriverModel? driver = await getDriver(route.ownerId);
      VehicleModel? vehicle = await getVehicleByOwner(route.ownerId);

      return {'route': route, 'driver': driver, 'vehicle': vehicle};
    } catch (e) {
      print('Erro ao buscar informações completas da rota: $e');
      return null;
    }
  }

  // Stream para ouvir mudanças nas rotas em tempo real
  Stream<List<RouteModel>> getRoutesStream() {
    return _firestore
        .collection('routes')
        .where('status', isEqualTo: 'Ativa')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return RouteModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }

  // Atualizar o ownerName de uma rota específica
  Future<void> updateRouteOwnerName(String routeId, String ownerName) async {
    try {
      await _firestore.collection('routes').doc(routeId).update({
        'ownerName': ownerName,
      });
    } catch (e) {
      print('Erro ao atualizar ownerName da rota: $e');
    }
  }

  // Sincronizar ownerName em todas as rotas que não possuem
  Future<void> syncOwnerNames() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('routes').get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Se a rota não tem ownerName ou está vazio, buscar do motorista
        if (data['ownerName'] == null || data['ownerName'].toString().isEmpty) {
          String ownerId = data['ownerId'] ?? '';
          if (ownerId.isNotEmpty) {
            DriverModel? driver = await getDriver(ownerId);
            if (driver != null) {
              await updateRouteOwnerName(doc.id, driver.name);
              print('Atualizado ownerName da rota ${doc.id}: ${driver.name}');
            }
          }
        }
      }
    } catch (e) {
      print('Erro ao sincronizar ownerNames: $e');
    }
  }

  // Buscar rotas e garantir que tenham ownerName preenchido
  Future<List<RouteModel>> getRoutesWithOwnerNames() async {
    try {
      List<RouteModel> routes = await getAvailableRoutes();

      // Para cada rota sem ownerName, buscar o nome do motorista
      for (int i = 0; i < routes.length; i++) {
        RouteModel route = routes[i];
        if (route.ownerName == 'Motorista' && route.ownerId.isNotEmpty) {
          DriverModel? driver = await getDriver(route.ownerId);
          if (driver != null) {
            // Atualizar no Firebase para futuras consultas
            await updateRouteOwnerName(route.id, driver.name);

            // Criar nova instância com ownerName atualizado
            routes[i] = RouteModel(
              id: route.id,
              origin: route.origin,
              destination: route.destination,
              duration: route.duration,
              price: route.price,
              availableSeats: route.availableSeats,
              capacity: route.capacity,
              ownerId: route.ownerId,
              ownerName: driver.name,
              status: route.status,
              timeSlots: route.timeSlots,
              tripsPerWeek: route.tripsPerWeek,
              createdAt: route.createdAt,
            );
          }
        }
      }

      return routes;
    } catch (e) {
      print('Erro ao buscar rotas com ownerNames: $e');
      return [];
    }
  }
}
