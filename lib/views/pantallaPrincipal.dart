import 'package:alcancia_movil/views/alcancia.dart';
import 'package:alcancia_movil/views/metas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/alcancia_provider.dart';
import 'widgets/menuDesplegablePrincipal.dart';

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final alcanciaProvider = context.watch<AlcanciaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      drawer: menuDesplegablePrincipal('lib/assets/images/logo.png', context),
      body: Column(
        children: [
          ImageLogo(
            width: 150,
            height: 130,
            image: 'lib/assets/images/logo.png',
          ),
          Text(
            "PocketMetrics",
            style: TextStyle(
              color: Colors.green,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Tu Analizador de Ahorros en el Bolsillo",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w100,
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Alcancia()),
                  );
                },
                child: Text('Alcancía'),
              ),
              SizedBox(width: 20),
              CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Metas()),
                  );
                },
                child: Text('Metas'),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            "Total Ahorrado: \$ ${alcanciaProvider.montoTotalAhorrado}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Metas",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: alcanciaProvider.metas.length,
              itemBuilder: (context, index) {
                final meta = alcanciaProvider.metas[index];
                final progress =
                    (meta.valorAhorrado / meta.valorObjetivo) * 100;
                final icon = meta.cumplida ? Icons.check_circle : Icons.circle;
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(icon, color: Colors.green),
                    title: Text(
                      meta.nombre,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      "${progress.toStringAsFixed(0)}%",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                );
              },
            ),
          ),
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
      {required this.width, required this.height, required this.image});

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

  const CustomButton({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
