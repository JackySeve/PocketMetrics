import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../home/menuDesplegablePrincipal.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final int selectionIndex =
        newValue.text.length - newValue.selection.extentOffset;
    final String newString =
        newValue.text.replaceAll(',', '').replaceAll('.', '');
    final String formattedString =
        NumberFormat.decimalPattern('es_CO').format(int.parse(newString));

    return TextEditingValue(
      text: formattedString,
      selection: TextSelection.collapsed(
        offset: formattedString.length - selectionIndex,
      ),
    );
  }
}

class Divisas extends StatefulWidget {
  const Divisas({super.key});

  @override
  _DivisasState createState() => _DivisasState();
}

class _DivisasState extends State<Divisas> {
  double _valorIngresado = 0;
  double _resultadoConversion = 0;
  String _monedaOrigen = 'COP';
  String _monedaDestino = 'USD';

  final List<Map<String, String>> _monedas = [
    {'code': 'COP', 'name': 'Peso Colombiano'},
    {'code': 'USD', 'name': 'Dólar Estadounidense'},
    {'code': 'EUR', 'name': 'Euro'},
    {'code': 'GBP', 'name': 'Libra Esterlina'},
    {'code': 'JPY', 'name': 'Yen Japonés'},
    {'code': 'CNY', 'name': 'Yuan Chino'},
    {'code': 'CAD', 'name': 'Dólar Canadiense'},
    {'code': 'CHF', 'name': 'Franco Suizo'},
    {'code': 'AUD', 'name': 'Dólar Australiano'},
    {'code': 'SEK', 'name': 'Corona Sueca'},
    {'code': 'NOK', 'name': 'Corona Noruega'},
    {'code': 'BRL', 'name': 'Real Brasileño'},
    {'code': 'MXN', 'name': 'Peso Mexicano'},
    {'code': 'INR', 'name': 'Rupia India'},
    {'code': 'RUB', 'name': 'Rublo Ruso'},
    {'code': 'SGD', 'name': 'Dólar de Singapur'},
    {'code': 'HKD', 'name': 'Dólar de Hong Kong'},
    {'code': 'KRW', 'name': 'Won Surcoreano'},
    {'code': 'ZAR', 'name': 'Rand Sudafricano'},
  ];

  final TextEditingController _valorController = TextEditingController();

  Future<void> _convertirMonedas() async {
    if (_monedaOrigen == _monedaDestino) {
      _mostrarError('La moneda de origen y destino no pueden ser la misma.');
      return;
    }

    final String url =
        'https://v6.exchangerate-api.com/v6/YOUR_API_KEY/latest/$_monedaOrigen';
    try {
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final double tasa = data['conversion_rates'][_monedaDestino];
        setState(() {
          _resultadoConversion = _valorIngresado * tasa;
        });
      } else {
        _mostrarError('No se pudo obtener la tasa de conversión.');
      }
    } catch (e) {
      _mostrarError('Error de conexión con la API.');
    }
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversor de Divisas')),
      drawer: MenuDesplegable(
        logo: 'lib/assets/images/logo.png',
        user: FirebaseAuth.instance.currentUser,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth > 600 ? 500 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildConversionCard(),
                  const Divider(),
                  _buildResultText(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConversionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputField(),
            _buildDropdown(_monedaOrigen, (value) {
              setState(() => _monedaOrigen = value!);
            }),
            _buildDropdown(_monedaDestino, (value) {
              setState(() => _monedaDestino = value!);
            }),
            _buildConvertButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return TextField(
      controller: _valorController,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      decoration: const InputDecoration(labelText: 'Ingrese un valor'),
      onChanged: (value) {
        setState(() {
          _valorIngresado = double.tryParse(
                  _valorController.text.replaceAll(RegExp(r'[,.]'), '')) ??
              0;
        });
      },
    );
  }

  Widget _buildDropdown(String value, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: _monedas.map((moneda) {
        return DropdownMenuItem<String>(
          value: moneda['code']!,
          child: Text('${moneda['name']} (${moneda['code']})'),
        );
      }).toList(),
    );
  }

  Widget _buildConvertButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
      ),
      onPressed: _convertirMonedas,
      child: const Text('Convertir'),
    );
  }

  Widget _buildResultText() {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'en_US');
    return Center(
      child: Text(
        'Resultado: ${formatter.format(_resultadoConversion)} $_monedaDestino',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
