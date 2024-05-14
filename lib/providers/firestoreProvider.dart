import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'package:alcancia_movil/views/metas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> initialize() async {
    // Inicializa la conexión con Firestore
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocument(
      String userId) {
    return _db.collection('usuarios').doc(userId).get();
  }

  Future<void> saveUserData(String userId, Map<String, dynamic> data) {
    return _db.collection('usuarios').doc(userId).set(data);
  }

  Future<void> saveTransaccion(Transaccion transaccion) {
    return _db.collection('transacciones').add({
      'nombre': transaccion.nombre,
      'monto': transaccion.monto,
      'fecha': transaccion.fecha,
    });
  }

  Future<void> saveMeta(Meta meta) {
    return _db.collection('metas').doc(meta.id).set(meta.toMap());
  }
}
