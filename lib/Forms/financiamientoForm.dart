// ignore_for_file: file_names

import 'package:alcancia_movil/Models/financiamiento_model.dart';
import 'package:alcancia_movil/providers/financiamiento_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FinanciamientoForm extends StatefulWidget {
  const FinanciamientoForm({super.key});

  @override
  State<FinanciamientoForm> createState() => _FinanciamientoFormState();
}

class _FinanciamientoFormState extends State<FinanciamientoForm> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  double _montoPrestamo = 0;
  double _tasaInteres = 0;
  int _plazoEnMeses = 12;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final financiamiento = FinanciamientoModel(
        id: _uuid.v4(),
        montoPrestamo: _montoPrestamo,
        tasaInteresAnual: _tasaInteres,
        plazoEnMeses: _plazoEnMeses,
      );

      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) return;

      Provider.of<FinanciamientoProvider>(context, listen: false)
          .addFinanciamiento(financiamiento, userEmail);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Financiamiento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Monto del préstamo'),
                inputFormatters: [ThousandsSeparatorInputFormatter()],
                keyboardType: TextInputType.number,
                validator: (value) {
                  final v = double.tryParse(value!.replaceAll(',', ''));
                  return (v == null || v <= 0)
                      ? 'Ingrese un monto válido'
                      : null;
                },
                onSaved: (value) =>
                    _montoPrestamo = double.parse(value!.replaceAll(',', '')),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Tasa de Interés Anual (%)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final v = double.tryParse(value ?? '');
                  return (v == null || v < 0)
                      ? 'Ingrese una tasa válida'
                      : null;
                },
                onSaved: (value) => _tasaInteres = double.parse(value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Plazo (meses)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final v = int.tryParse(value ?? '');
                  return (v == null || v <= 0)
                      ? 'Ingrese un plazo válido'
                      : null;
                },
                onSaved: (value) => _plazoEnMeses = int.parse(value!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Calcular y Guardar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;
    final number = int.tryParse(newValue.text.replaceAll(RegExp(r'[,.]'), ''));
    if (number == null) return newValue;

    final newString = NumberFormat.decimalPattern().format(number);
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight),
    );
  }
}
