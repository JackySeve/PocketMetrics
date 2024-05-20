import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/alcancia_provider.dart';
import 'widgets/menuDesplegablePrincipal.dart';
import 'alcancia.dart';
import 'metas.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({Key? key}) : super(key: key);

  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  late Future<void> _loadData;

  // Definir el correo electrónico del usuario aquí
  final String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
    _loadData = _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final alcanciaProvider =
          Provider.of<AlcanciaProvider>(context, listen: false);
      await alcanciaProvider.verificarFechaMetas();
      if (mounted) {
        await _descargarDatosDesdeFirebase(alcanciaProvider, userEmail);
        await alcanciaProvider.cargarMetasDesdeFirebase(userEmail);
        await alcanciaProvider.cargarTransaccionesDesdeFirebase(userEmail);
      }
    } catch (error) {
      // Manejar errores aquí
      print('Error al cargar datos: $error');
    }
  }

  Future<void> _descargarDatosDesdeFirebase(
      AlcanciaProvider alcanciaProvider, String userEmail) async {
    if (mounted) {
      await alcanciaProvider.cargarDatosDesdeFirebase(userEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alcanciaProvider = Provider.of<AlcanciaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      drawer: menuDesplegablePrincipal(
        'lib/assets/images/logo.png',
        context,
        user: FirebaseAuth.instance.currentUser,
      ),
      body: FutureBuilder<void>(
        future: _loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return _buildBody(alcanciaProvider);
          }
        },
      ),
    );
  }

  Widget _buildBody(AlcanciaProvider alcanciaProvider) {
    return Column(
      children: [
        const ImageLogo(
          width: 150,
          height: 130,
          image: 'lib/assets/images/logo.png',
        ),
        const Text(
          "PocketMetrics",
          style: TextStyle(
            color: Colors.green,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Tu Analizador de Ahorros en el Bolsillo",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w100,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Alcancia()),
                );
              },
              child: const Text('Alcancía'),
            ),
            const SizedBox(width: 20),
            CustomButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Metas()),
                );
              },
              child: const Text('Metas'),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          "Total Ahorrado: \$ ${alcanciaProvider.montoTotalAhorrado}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Metas",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: alcanciaProvider.metas.length,
            itemBuilder: (context, index) {
              final meta = alcanciaProvider.metas[index];
              final progress = (meta.valorAhorrado / meta.valorObjetivo) * 100;
              final icon = meta.cumplida ? Icons.check_circle : Icons.circle;
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(icon, color: Colors.green),
                  title: Text(
                    meta.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    "${progress.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ImageLogo extends StatelessWidget {
  final double width;
  final double height;
  final String image;

  const ImageLogo({
    Key? key,
    required this.width,
    required this.height,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: width,
      height: height,
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: child,
    );
  }
}
