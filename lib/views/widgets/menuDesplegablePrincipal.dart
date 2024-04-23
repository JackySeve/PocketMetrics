import 'dart:io';

import 'package:alcancia_movil/views/ajustes.dart';
import 'package:alcancia_movil/views/alcancia.dart';
import 'package:alcancia_movil/views/avanzados.dart';
import 'package:alcancia_movil/views/estadisticos.dart';
import 'package:alcancia_movil/views/historial.dart';
import 'package:alcancia_movil/views/metas.dart';
import 'package:alcancia_movil/views/pantallaPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

SizedBox menuDesplegablePrincipal(String logo, BuildContext context) {
  return SizedBox(
      width: 220,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
                height: 200.0,
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
                      child: const Text("PocketMetrics",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 26,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ))),
            Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 226, 225, 225)),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 30),
                leading: const Icon(
                  Icons.apps,
                  color: Color.fromRGBO(16, 162, 31, 1),
                  size: 40,
                ),
                title: const Text(
                  "Inicio",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => pantallaPrincipal(
                              valorTotalAhorrado:
                                  const alcancia().valorTotalAhorrado,
                            )),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 226, 225, 225)),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 30),
                leading: const Icon(
                  Icons.account_balance,
                  color: Color.fromRGBO(16, 162, 31, 1),
                  size: 40,
                ),
                title: const Text(
                  "Alcancía",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const alcancia()),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 226, 225, 225)),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 30),
                leading: const Icon(
                  Icons.history,
                  color: Color.fromRGBO(16, 162, 31, 1),
                  size: 40,
                ),
                title: const Text(
                  'Historial de Movimientos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const historial()),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 226, 225, 225)),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 30),
                leading: const Icon(
                  Icons.equalizer,
                  color: Color.fromRGBO(16, 162, 31, 1),
                  size: 40,
                ),
                title: const Text(
                  "Estadísticos",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const estadisticos()),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 226, 225, 225)),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 30),
                leading: const Icon(
                  Icons.trending_up,
                  color: Color.fromRGBO(16, 162, 31, 1),
                  size: 40,
                ),
                title: const Text(
                  "Avanzados",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const avanzados()),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 226, 225, 225)),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 30),
                leading: const Icon(
                  Icons.flag,
                  color: Color.fromRGBO(16, 162, 31, 1),
                  size: 40,
                ),
                title: const Text(
                  "Metas",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const metas()),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 226, 225, 225)),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 30),
                leading: const Icon(
                  Icons.settings,
                  color: Color.fromRGBO(16, 162, 31, 1),
                  size: 40,
                ),
                title: const Text(
                  "Ajustes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ajustes()),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 226, 225, 225)),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 30),
                leading: const Icon(
                  Icons.input,
                  color: Color.fromRGBO(16, 162, 31, 1),
                  size: 40,
                ),
                title: const Text(
                  "Cerrar Sesión",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  SystemNavigator.pop();
                },
              ),
            ),
          ],
        ),
      ));
}
