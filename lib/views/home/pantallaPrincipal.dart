// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print

import 'package:alcancia_movil/providers/divisas_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/alcancia_provider.dart';
import 'menuDesplegablePrincipal.dart';
import '../features/alcancia.dart';
import '../features/metas.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  late Future<void> _loadData;
  final String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
    _loadData = _cargarDatos();
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      Provider.of<DivisasProvider>(context, listen: false)
          .cargarDivisasDesdeFirebase(userEmail);
    }
  }

  Future<void> _cargarDatos() async {
    try {
      final alcanciaProvider =
          Provider.of<AlcanciaProvider>(context, listen: false);
      await alcanciaProvider.verificarFechaMetas();
      if (mounted) {
        await alcanciaProvider.cargarDatosDesdeFirebase(userEmail);
        await alcanciaProvider.cargarMetasDesdeFirebase(userEmail);
        await alcanciaProvider.cargarTransaccionesDesdeFirebase(userEmail);
      }
    } catch (error) {
      print('Error al cargar datos: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      drawer: MenuDesplegable(
          logo: 'lib/assets/images/logo.png',
          user: FirebaseAuth.instance.currentUser),
      body: FutureBuilder<void>(
        future: _loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomLoadingAnimation());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return _buildBody(context);
          }
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final alcanciaProvider = Provider.of<AlcanciaProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(constraints.maxWidth * 0.05),
          child: Column(
            children: [
              const ImageLogo(
                  width: 150, height: 130, image: 'lib/assets/images/logo.png'),
              const Text(
                "PocketMetrics",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tu Analizador de Ahorros en el Bolsillo",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      onPressed: () => _navigateTo(context, const Alcancia()),
                      child: const Text('Alcancía')),
                  const SizedBox(width: 20),
                  CustomButton(
                      onPressed: () => _navigateTo(context, const Metas()),
                      child: const Text('Metas')),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                "Total Ahorrado: ${formatCurrency(alcanciaProvider.montoTotalAhorrado)}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildMetasList(alcanciaProvider)
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetasList(AlcanciaProvider alcanciaProvider) {
    return Column(
      children: alcanciaProvider.metas.map((meta) {
        final progress = (meta.valorAhorrado / meta.valorObjetivo);
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(meta.cumplida ? Icons.check_circle : Icons.circle,
                color: Colors.green),
            title: Text(meta.nombre,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            trailing: Text("${(progress * 100).toStringAsFixed(0)}%"),
            subtitle: LinearProgressIndicator(
              value: meta.valorAhorrado / meta.valorObjetivo,
              backgroundColor: Colors.grey[400],
              valueColor: AlwaysStoppedAnimation<Color>(
                meta.valorAhorrado / meta.valorObjetivo >= 1
                    ? Colors.green
                    : meta.valorAhorrado / meta.valorObjetivo >= 0.5
                        ? Colors.orange
                        : Colors.red,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  String formatCurrency(num amount) {
    final format = NumberFormat.currency(locale: 'es_CO', symbol: '\$');
    return format.format(amount);
  }
}

class CustomLoadingAnimation extends StatelessWidget {
  const CustomLoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.green),
          const SizedBox(height: 10),
          const Text("Cargando datos...", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class ImageLogo extends StatelessWidget {
  final double width;
  final double height;
  final String image;

  const ImageLogo(
      {super.key,
      required this.width,
      required this.height,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Image.asset(image, width: width, height: height);
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const CustomButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
      ),
      child: child,
    );
  }
}
