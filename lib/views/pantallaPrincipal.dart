import 'package:alcancia_movil/views/alcancia.dart';
import 'package:alcancia_movil/views/metas.dart';
import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
import 'package:flutter/material.dart';

class pantallaPrincipal extends StatelessWidget {
  final int valorTotalAhorrado;

  pantallaPrincipal({required this.valorTotalAhorrado});

  @override
  Widget build(BuildContext context) {
    final logo = 'lib/assets/images/logo.png';
    return Scaffold(
        appBar: AppBar(),
        drawer: menuDesplegablePrincipal(logo, context),
        body: Center(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                        child: Image.asset(
                      logo,
                      width: 150,
                      height: 130,
                    )),
                    Container(
                      child: Text("PocketMetrics",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      child: Text(
                        "Tu Analizador de Ahorros en el Bolsillo",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w100),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => alcancia()),
                            );
                          },
                          child: Text('Alcancía'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => metas()),
                            );
                          },
                          child: Text('Metas'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    Container(
                      child: Text("Total Ahorrado",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      child: Text(
                        "\$ " "$valorTotalAhorrado",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
