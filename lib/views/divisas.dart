import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'widgets/menuDesplegablePrincipal.dart';

class Divisas extends StatefulWidget {
  const Divisas({Key? key}) : super(key: key);

  @override
  _DivisasState createState() => _DivisasState();
}

class _DivisasState extends State<Divisas> {
  double _valorIngresado = 0;
  double _resultadoConversion = 0;
  String _monedaOrigen = 'COP';
  String _monedaDestino = 'USD';

  final List<String> _monedas = [
    'COP',
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CNY',
    'CAD',
    'CHF',
    'AUD',
    'SEK',
    'NOK',
  ];

  Future<void> _convertirMonedas() async {
    if (_monedaOrigen == _monedaDestino) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'La moneda de origen y destino no pueden ser la misma.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return;
    }

    final String url =
        'https://api.exchangerate-api.com/v4/latest/$_monedaOrigen';
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final double tasa = data['rates'][_monedaDestino];
      setState(() {
        _resultadoConversion = _valorIngresado * tasa;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('No se pudo obtener la tasa de conversión.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const logo = 'lib/assets/images/logo.png';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Divisas'),
      ),
      drawer: menuDesplegablePrincipal(logo, context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ingrese un valor',
              ),
              onChanged: (value) {
                setState(() {
                  _valorIngresado = double.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _monedaOrigen,
              onChanged: (value) {
                setState(() {
                  _monedaOrigen = value!;
                });
              },
              items: _monedas.map((moneda) {
                return DropdownMenuItem<String>(
                  value: moneda,
                  child: Text(moneda),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _monedaDestino,
              onChanged: (value) {
                setState(() {
                  _monedaDestino = value!;
                });
              },
              items: _monedas.map((moneda) {
                return DropdownMenuItem<String>(
                  value: moneda,
                  child: Text(moneda),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _convertirMonedas,
              child: const Text('Convertir'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Resultado: $_resultadoConversion $_monedaDestino',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
