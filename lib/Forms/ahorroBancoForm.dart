// ignore_for_file: file_names

import 'package:alcancia_movil/Models/bank_saving_model.dart';
import 'package:alcancia_movil/providers/bank_savings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BankSavingForm extends StatefulWidget {
  final BankSaving? editSaving;
  final String userEmail;

  const BankSavingForm({super.key, this.editSaving, required this.userEmail});

  @override
  State<BankSavingForm> createState() => _BankSavingFormState();
}

class _BankSavingFormState extends State<BankSavingForm> {
  final _formKey = GlobalKey<FormState>();

  late String _bankName;
  late String _accountType;
  late double _amount;
  late DateTime _lastUpdated;

  @override
  void initState() {
    super.initState();
    if (widget.editSaving != null) {
      _bankName = widget.editSaving!.bankName;
      _accountType = widget.editSaving!.accountType;
      _amount = widget.editSaving!.amount;
      _lastUpdated = widget.editSaving!.lastUpdated;
    } else {
      _bankName = '';
      _accountType = 'Ahorros';
      _amount = 0.0;
      _lastUpdated = DateTime.now();
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newSaving = BankSaving(
        id: widget.editSaving?.id ?? UniqueKey().toString(),
        bankName: _bankName,
        accountType: _accountType,
        amount: _amount,
        lastUpdated: _lastUpdated,
      );

      final provider = Provider.of<BankSavingsProvider>(context, listen: false);
      if (widget.editSaving != null) {
        provider.updateSaving(newSaving, widget.userEmail);
      } else {
        provider.addSaving(newSaving, widget.userEmail);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastUpdated,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _lastUpdated = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.editSaving != null ? 'Editar Ahorro' : 'Nuevo Ahorro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _bankName,
                decoration:
                    const InputDecoration(labelText: 'Nombre del Banco'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
                onSaved: (value) => _bankName = value!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _accountType,
                decoration: const InputDecoration(labelText: 'Tipo de Cuenta'),
                items: const [
                  DropdownMenuItem(value: 'Ahorros', child: Text('Ahorros')),
                  DropdownMenuItem(
                      value: 'Corriente', child: Text('Corriente')),
                ],
                onChanged: (value) => setState(() {
                  _accountType = value!;
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _amount > 0 ? _amount.toString() : '',
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Cantidad de Dinero'),
                inputFormatters: [ThousandsSeparatorInputFormatter()],
                onSaved: (value) {
                  _amount = double.tryParse(
                        value!.replaceAll(RegExp(r'[,.]'), ''),
                      ) ??
                      0;
                },
                validator: (value) {
                  final amount = double.tryParse(
                    value!.replaceAll(RegExp(r'[,.]'), ''),
                  );
                  if (amount == null || amount <= 0) {
                    return 'Debe ser mayor a cero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Fecha de Actualización'),
                subtitle: Text(
                    '${_lastUpdated.day}/${_lastUpdated.month}/${_lastUpdated.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 24),
              ElevatedButton( 
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child:
                    Text(widget.editSaving != null ? 'Actualizar' : 'Guardar', style: TextStyle(color: Colors.white)),
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
