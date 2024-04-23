import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
import 'package:flutter/material.dart';

class ajustes extends StatelessWidget {
  const ajustes({super.key});

  @override
  Widget build(BuildContext context) {
    const logo = 'lib/assets/images/logo.png';
    return Scaffold(
      appBar: AppBar(),
      drawer: menuDesplegablePrincipal(logo, context),
    );
  }
}
