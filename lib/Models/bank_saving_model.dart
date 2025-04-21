import 'package:cloud_firestore/cloud_firestore.dart';

class BankSaving {
  final String id;
  final String bankName;
  final String accountType;
  final double amount;
  final DateTime lastUpdated;

  BankSaving({
    required this.id,
    required this.bankName,
    required this.accountType,
    required this.amount,
    required this.lastUpdated,
  });

  // Método para convertir el documento de Firestore en un objeto de tipo BankSaving
  factory BankSaving.fromJson(Map<String, dynamic> json, String id) {
    return BankSaving(
      id: id,
      bankName: json['bankName'],
      accountType: json['accountType'],
      amount: (json['amount'] as num).toDouble(),
      lastUpdated: (json['lastUpdated'] as Timestamp).toDate(), // Asumiendo que 'lastUpdated' es un Timestamp en Firestore
    );
  }

  // Método para convertir el objeto BankSaving en un mapa de claves y valores (JSON)
  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountType': accountType,
      'amount': amount,
      'lastUpdated': lastUpdated,
    };
  }
}
