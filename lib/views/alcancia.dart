import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
import 'package:flutter/material.dart';

class alcancia extends StatefulWidget {
  @override
  State<alcancia> createState() => _alcanciaState();

  int get valorTotalAhorrado => _alcanciaState().valorTotalAhorrado;
}

class _alcanciaState extends State<alcancia> {
  int moneda50 = 0;
  int moneda100 = 0;
  int get valorTotalAhorrado => moneda50 * 50 + moneda100 * 100;

  @override
  Widget build(BuildContext context) {
    final logo = 'lib/assets/images/logo.png';
    return Scaffold(
      appBar: AppBar(),
      drawer: menuDesplegablePrincipal(logo, context),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Text(
                'Monedas',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    '50: ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      moneda50 = moneda50 > 0 ? moneda50 - 1 : 0;
                    });
                  },
                  child: Text(
                    '-',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)),
                  child: Text(
                    '$moneda50',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      moneda50++;
                    });
                  },
                  child: Text(
                    '+',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    '100: ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      moneda100 = moneda100 > 0 ? moneda100 - 1 : 0;
                    });
                  },
                  child: Text(
                    '-',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)),
                  child: Text(
                    '$moneda100',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      moneda100++;
                    });
                  },
                  child: Text(
                    '+',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            Container(
              child: Text('Total Ahorrado: $valorTotalAhorrado'),
            )
          ],
        ),
      ),
    );
  }
}
