import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
import 'package:flutter/material.dart';

class alcancia extends StatefulWidget {
  const alcancia({super.key});

  @override
  State<alcancia> createState() => _alcanciaState();

  int get valorTotalAhorrado => _alcanciaState().totalAhorrado;
}

class Moneda {
  final int valor;
  int cantidad;

  Moneda(this.valor, {this.cantidad = 0});

  int get total => valor * cantidad;
}

class Billete {
  final int valor;
  int cantidad;

  Billete(this.valor, {this.cantidad = 0});

  int get total => valor * cantidad;
}

class alcanciaState extends StatefulWidget {
  @override
  _alcanciaState createState() => _alcanciaState();
}

class _alcanciaState extends State<alcancia> {
  List<Moneda> monedas = [
    Moneda(50),
    Moneda(100),
    Moneda(200),
    Moneda(500),
    Moneda(1000),
  ];

  List<Billete> billetes = [
    Billete(1000),
    Billete(2000),
    Billete(5000),
    Billete(10000),
    Billete(20000),
    Billete(50000),
    Billete(100000),
  ];

  int get totalAhorrado {
    int total = 0;
    for (var moneda in monedas) {
      total += moneda.total;
    }
    for (var billete in billetes) {
      total += billete.total;
    }
    return total;
  }

  int get totalAhorradoMonedas {
    int total = 0;
    for (var moneda in monedas) {
      total += moneda.total;
    }
    return total;
  }

  int get totalAhorradoBilletes {
    int total = 0;
    for (var billete in billetes) {
      total += billete.total;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    const logo = 'lib/assets/images/logo.png';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Ahorros'),
      ),
      drawer: menuDesplegablePrincipal(logo, context),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text('Monedas:'),
            SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Valor'),
                SizedBox(width: 20),
                Text('Cantidad'),
                SizedBox(width: 20),
                Text('Total'),
              ],
            ),
            Column(
              children: monedas.map((moneda) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${moneda.valor}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          moneda.cantidad++;
                        });
                      },
                    ),
                    Text("${moneda.cantidad}"),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (moneda.cantidad > 0) {
                            moneda.cantidad--;
                          }
                        });
                      },
                    ),
                    Text("\$ ${moneda.valor * moneda.cantidad}")
                  ],
                );
              }).toList(),
            ),
            Text('Total Ahorrado (Monedas): \$ $totalAhorradoMonedas',
                style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            Text('Billetes:'),
            SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Valor'),
                SizedBox(width: 20),
                Text('Cantidad'),
                SizedBox(width: 20),
                Text('Total'),
              ],
            ),
            Column(
              children: billetes.map((billete) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${billete.valor}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          billete.cantidad++;
                        });
                      },
                    ),
                    Text("${billete.cantidad}"),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (billete.cantidad > 0) {
                            billete.cantidad--;
                          }
                        });
                      },
                    ),
                    Text("\$ ${billete.valor * billete.cantidad}")
                  ],
                );
              }).toList(),
            ),
            Text('Total Ahorrado (Billetes): \$ $totalAhorradoBilletes',
                style: TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            Text(
              "Total Ahorrado: ${totalAhorrado}",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
