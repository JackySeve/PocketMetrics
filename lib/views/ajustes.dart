import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({super.key});

  @override
  _AjustesState createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  double _fontSize = 16;
  String _fontFamily = 'Roboto';
  Color? _textColor;

  Future<void> _showColorDialog(BuildContext context) async {
    final List<Color> colors = [
      Colors.black,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.brown,
      Colors.grey,
    ];
    final Color? selectedColor = await showDialog<Color>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Seleccione un color'),
          children: colors.map<Widget>(
            (color) {
              return SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, color);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            color: color,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        );
      },
    );
    if (selectedColor != null && selectedColor != _textColor) {
      setState(() {
        _textColor = selectedColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const logo = 'lib/assets/images/logo.png';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      drawer: menuDesplegablePrincipal(
        logo,
        context,
        user: FirebaseAuth.instance.currentUser,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Ajustes'),
            const SizedBox(height: 16),
            const Text('Tamaño de letra',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _fontSize,
              min: 12,
              max: 24,
              onChanged: (value) {
                if (value >= 12 && value <= 24) {
                  setState(() {
                    _fontSize = value;
                  });
                }
              },
            ),
            Text('${_fontSize.toInt()} puntos',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Tipografía de letra',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _fontFamily,
              onChanged: (value) {
                setState(() {
                  _fontFamily = value!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'Roboto',
                  child: Text('Roboto'),
                ),
                DropdownMenuItem(
                  value: 'Arial',
                  child: Text('Arial'),
                ),
                DropdownMenuItem(
                  value: 'Times New Roman',
                  child: Text('Times New Roman'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Color de letra',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {
                _showColorDialog(context);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: _textColor ?? Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Este es un ejemplo de texto con las propiedades seleccionadas.',
              style: TextStyle(
                fontSize: _fontSize,
                fontFamily: _fontFamily,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _fontSize = 16;
                    _fontFamily = 'Roboto';
                    _textColor = Colors.black;
                  });
                },
                child: const Center(child: Text('Restablecer')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
