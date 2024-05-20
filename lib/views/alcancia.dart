import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/alcancia_provider.dart';
import 'widgets/menuDesplegablePrincipal.dart';

class Alcancia extends StatelessWidget {
  const Alcancia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alcanciaProvider =
        Provider.of<AlcanciaProvider>(context, listen: true);
    const logo = 'lib/assets/images/logo.png';
    final userEmail = FirebaseAuth.instance.currentUser
        ?.email; // Obtener el correo electrónico del usuario actual

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Alcancía'),
      ),
      drawer: menuDesplegablePrincipal(
        logo,
        context,
        user: FirebaseAuth.instance.currentUser,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Monedas:'),
            const SizedBox(height: 10),
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
              children: alcanciaProvider.monedas.asMap().entries.map((entry) {
                final index = entry.key;
                final moneda = entry.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${moneda.valor}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        const esIngreso = true;
                        final monto = moneda.valor.toDouble();
                        alcanciaProvider.agregarTransaccion(
                            monto, esIngreso, userEmail!);
                        alcanciaProvider.actualizarCantidadMoneda(
                            index, moneda.cantidad + 1, userEmail);
                        alcanciaProvider.guardarDatosEnFirebase(
                          alcanciaProvider.monedas,
                          alcanciaProvider.billetes,
                          alcanciaProvider.totalAhorrado.toDouble(),
                          userEmail, // Asegúrate de definir userEmail
                        );
                      },
                    ),
                    Text("${moneda.cantidad}"),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (moneda.cantidad > 0) {
                          const esIngreso = false;
                          final monto = moneda.valor.toDouble();
                          alcanciaProvider.agregarTransaccion(
                              monto, esIngreso, userEmail!);
                          alcanciaProvider.actualizarCantidadMoneda(
                              index, moneda.cantidad - 1, userEmail);
                          alcanciaProvider.guardarDatosEnFirebase(
                            alcanciaProvider.monedas,
                            alcanciaProvider.billetes,
                            alcanciaProvider.totalAhorrado.toDouble(),
                            userEmail, // Asegúrate de definir userEmail
                          );
                        }
                      },
                    ),
                    Text("\$ ${moneda.valor * moneda.cantidad}")
                  ],
                );
              }).toList(),
            ),
            Text(
              'Total Ahorrado (Monedas): \$ ${alcanciaProvider.totalAhorradoMonedas}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            const Text('Billetes:'),
            const SizedBox(height: 10),
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
              children: alcanciaProvider.billetes.asMap().entries.map((entry) {
                final index = entry.key;
                final billete = entry.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${billete.valor}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        const esIngreso = true;
                        final monto = billete.valor.toDouble();
                        alcanciaProvider.agregarTransaccion(
                            monto, esIngreso, userEmail!);
                        alcanciaProvider.actualizarCantidadBillete(
                            index, billete.cantidad + 1, userEmail);
                        alcanciaProvider.guardarDatosEnFirebase(
                          alcanciaProvider.monedas,
                          alcanciaProvider.billetes,
                          alcanciaProvider.totalAhorrado.toDouble(),
                          userEmail, // Asegúrate de definir userEmail
                        );
                      },
                    ),
                    Text("${billete.cantidad}"),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (billete.cantidad > 0) {
                          const esIngreso = false;
                          final monto = billete.valor.toDouble();
                          alcanciaProvider.agregarTransaccion(
                              monto, esIngreso, userEmail!);
                          alcanciaProvider.actualizarCantidadBillete(
                              index, billete.cantidad - 1, userEmail);
                          alcanciaProvider.guardarDatosEnFirebase(
                            alcanciaProvider.monedas,
                            alcanciaProvider.billetes,
                            alcanciaProvider.totalAhorrado.toDouble(),
                            userEmail, // Asegúrate de definir userEmail
                          );
                        }
                      },
                    ),
                    Text("\$ ${billete.valor * billete.cantidad}")
                  ],
                );
              }).toList(),
            ),
            Text(
              'Total Ahorrado (Billetes): \$ ${alcanciaProvider.totalAhorradoBilletes}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            Text(
              "Total Ahorrado: ${alcanciaProvider.totalAhorrado}",
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
