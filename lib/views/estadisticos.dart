import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
import 'package:flutter/material.dart';

class estadisticos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logo = 'lib/assets/images/logo.png';
    return Scaffold(
      appBar: AppBar(),
      drawer: menuDesplegablePrincipal(logo, context),
    );
  }
}
