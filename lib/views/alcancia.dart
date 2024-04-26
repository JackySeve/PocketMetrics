import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Alcancia extends StatelessWidget {
  const Alcancia({super.key});

  @override
  Widget build(BuildContext context) {
    final alcanciaProvider = context.watch<AlcanciaProvider>();
    const logo = 'lib/assets/images/logo.png';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ahorros'),
      ),
      drawer: menuDesplegablePrincipal(logo, context),
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
                        final esIngreso = true;
                        final monto = moneda.valor.toDouble();
                        alcanciaProvider.agregarTransaccion(monto, esIngreso);
                        alcanciaProvider.actualizarCantidadMoneda(
                            index, moneda.cantidad + 1);
                      },
                    ),
                    Text("${moneda.cantidad}"),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (moneda.cantidad > 0) {
                          final esIngreso = false;
                          final monto = moneda.valor.toDouble();
                          alcanciaProvider.agregarTransaccion(monto, esIngreso);
                          alcanciaProvider.actualizarCantidadMoneda(
                              index, moneda.cantidad - 1);
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
                        final esIngreso = true;
                        final monto = billete.valor.toDouble();
                        alcanciaProvider.agregarTransaccion(monto, esIngreso);
                        alcanciaProvider.actualizarCantidadBillete(
                            index, billete.cantidad + 1);
                      },
                    ),
                    Text("${billete.cantidad}"),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (billete.cantidad > 0) {
                          final esIngreso = false;
                          final monto = billete.valor.toDouble();
                          alcanciaProvider.agregarTransaccion(monto, esIngreso);
                          alcanciaProvider.actualizarCantidadMoneda(
                              index, billete.cantidad - 1);
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
