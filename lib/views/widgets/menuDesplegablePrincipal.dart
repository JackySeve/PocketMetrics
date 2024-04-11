import 'package:alcancia_movil/views/ajustes.dart';
import 'package:alcancia_movil/views/alcancia.dart';
import 'package:alcancia_movil/views/avanzados.dart';
import 'package:alcancia_movil/views/estadisticos.dart';
import 'package:alcancia_movil/views/historial.dart';
import 'package:alcancia_movil/views/metas.dart';
import 'package:alcancia_movil/views/pantallaPrincipal.dart';
import 'package:flutter/material.dart';

Container menuDesplegablePrincipal(String logo, BuildContext context) {
  return Container(
      width: 220,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
                height: 185.0,
                child: DrawerHeader(
                    child: Column(
                  children: [
                    Container(
                        child: Image.asset(
                      logo,
                      width: 100,
                      height: 85,
                    )),
                    Container(
                      child: Text("PocketMetrics",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 26,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ))),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              leading: Icon(
                Icons.apps,
                color: Color.fromRGBO(16, 162, 31, 1),
                size: 40,
              ),
              title: Text(
                "Inicio",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => pantallaPrincipal(
                            valorTotalAhorrado: alcancia().valorTotalAhorrado,
                          )),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              leading: Icon(
                Icons.account_balance,
                color: Color.fromRGBO(16, 162, 31, 1),
                size: 40,
              ),
              title: Text(
                "Alcancía",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
              leading: Icon(
                Icons.history,
                color: Color.fromRGBO(16, 162, 31, 1),
                size: 40,
              ),
              title: Text(
                'Historial de Movimientos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => historial()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              leading: Icon(
                Icons.equalizer,
                color: Color.fromRGBO(16, 162, 31, 1),
                size: 40,
              ),
              title: Text(
                "Estadísticos",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
              leading: Icon(
                Icons.trending_up,
                color: Color.fromRGBO(16, 162, 31, 1),
                size: 40,
              ),
              title: Text(
                "Avanzados",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
              leading: Icon(
                Icons.flag,
                color: Color.fromRGBO(16, 162, 31, 1),
                size: 40,
              ),
              title: Text(
                "Metas",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
              leading: Icon(
                Icons.settings,
                color: Color.fromRGBO(16, 162, 31, 1),
                size: 40,
              ),
              title: Text(
                "Ajustes",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ajustes()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              leading: Icon(
                Icons.input,
                color: Color.fromRGBO(16, 162, 31, 1),
                size: 40,
              ),
              title: Text(
                "Cerrar Sesión",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
      ));
}
