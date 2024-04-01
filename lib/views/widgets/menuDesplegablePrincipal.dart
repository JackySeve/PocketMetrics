import 'package:alcancia_movil/views/ajustes.dart';
import 'package:alcancia_movil/views/alcancia.dart';
import 'package:alcancia_movil/views/avanzados.dart';
import 'package:alcancia_movil/views/estadisticos.dart';
import 'package:alcancia_movil/views/metas.dart';
import 'package:alcancia_movil/views/pantallaPrincipal.dart';
import 'package:flutter/material.dart';

Drawer menuDesplegablePrincipal(String logo, BuildContext context) {
  return Drawer(
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
                      fontWeight: FontWeight.bold)),
            ),
          ],
        )),
        ListTile(
          contentPadding: EdgeInsets.only(left: 30),
          leading: Icon(Icons.apps),
          title: Text("Menú"),
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
  );
}
