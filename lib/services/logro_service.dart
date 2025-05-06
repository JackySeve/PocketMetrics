import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/logro_model.dart';
import '../data/logros_iniciales.dart'; // Asegúrate de tener esta lista bien definida

class LogrosService {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LogrosService({required this.userId});

  // 🔄 Obtener todos los logros del usuario desde Firestore
  Future<List<Logro>> obtenerLogros() async {
    final snapshot = await _firestore
        .collection('usuarios')
        .doc(userId)
        .collection('logros')
        .get();

    return snapshot.docs
        .map((doc) => Logro.fromMap(doc.data(), doc.id))
        .toList();
  }

  // 💾 Actualizar un logro específico en Firestore
  Future<void> actualizarLogro(Logro logro) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('logros')
          .doc(logro.id)
          .set(logro.toMap());
    } catch (e) {
      print('Error actualizando logro ${logro.id}: $e');
    }
  }

  // 🧠 Inicializar logros por primera vez si el usuario no tiene ninguno
  Future<void> inicializarLogros() async {
    final ref =
        _firestore.collection('usuarios').doc(userId).collection('logros');

    final snapshot = await ref.get();
    if (snapshot.docs.isEmpty) {
      for (final logro in logrosIniciales) {
        await ref.doc(logro.id).set(logro.toMap());
      }
    }
  }

  // 🧪 Evaluar si el usuario cumple condiciones para desbloquear logros
  Future<void> evaluarLogros({
    required double ahorroTotal,
    required int transacciones,
    required int nivel,
  }) async {
    await inicializarLogros();
    final logros = await obtenerLogros();

    // Define criterios dinámicos para cada logro
    final Map<String, bool Function()> criterios = {
      'ahorro_inicial': () => ahorroTotal >= 100,
      'transacciones_10': () => transacciones >= 10,
      'nivel_15': () => nivel >= 15,
      // Puedes añadir más aquí
    };

    for (final logro in logros) {
      final cumple = criterios[logro.id]?.call() ?? false;
      if (cumple && !logro.completado) {
        final actualizado = logro.copyWith(
          completado: true,
          fechaLogro: DateTime.now(),
        );
        await actualizarLogro(actualizado);
      }
    }
  }
}
