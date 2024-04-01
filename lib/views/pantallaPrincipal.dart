import 'package:alcancia_movil/views/alcancia.dart';
import 'package:alcancia_movil/views/avanzados.dart';
import 'package:alcancia_movil/views/estadisticos.dart';
import 'package:alcancia_movil/views/metas.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ajustes.dart';

class pantallaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logo = 'lib/assets/images/logo.png';
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                child: Column(
              children: [
                Container(
                    child: Image.asset(
                  logo,
                  width: 120,
                  height: 95,
                )),
                Container(
                  child: Text("PocketMetrics",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 25,
                          fontWeight: FontWeight.w900)),
                ),
              ],
            )),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              leading: Icon(Icons.account_balance),
              title: Text("Alcancía"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => alcancia()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              leading: Icon(Icons.equalizer),
              title: Text("Estadísticos"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => estadisticos()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              leading: Icon(Icons.trending_up),
              title: Text("Avanzados"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => avanzados()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              leading: Icon(Icons.flag),
              title: Text("Metas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => metas()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              leading: Icon(Icons.settings),
              title: Text("Ajustes"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ajustes()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 55),
              child: Column(
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
                            fontWeight: FontWeight.w900)),
                  ),
                  Container(
                    child: Text(
                      "Tu Analizador de Ahorros en el Bolsillo",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            Column(
              children: [
                Container(
                  child: Text("Total Ahorrado",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                ),
                Container(
                  child: Text(
                    "\$00000000000",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
