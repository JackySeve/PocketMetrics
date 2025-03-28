import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../auth/inicioSesionUsuario.dart';
import '../auth/registroUsuario.dart';

class InicioPrincipal extends StatefulWidget {
  const InicioPrincipal({super.key});

  @override
  _InicioPrincipalState createState() => _InicioPrincipalState();
}

class _InicioPrincipalState extends State<InicioPrincipal> {
  String appVersion = "Cargando...";

  @override
  void initState() {
    super.initState();
    _cargarVersion();
  }

  Future<void> _cargarVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = "Versión: ${packageInfo.version}+${packageInfo.buildNumber}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.1),
                  ImageLogo(
                    width: size.width * 0.6,
                    height: size.height * 0.25,
                    image: 'lib/assets/images/logo.png',
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    "PocketMetrics",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: size.width * 0.12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Asap',
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    '¡Bienvenido de nuevo! Es un placer poderte servir',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Asap',
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  BotonPrincipal(
                    texto: "Iniciar Sesión",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InicioSesionUsuario()),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    "¿Eres nuevo? Únete e inicia una nueva forma de organizar tus metas financieras",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Asap',
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  BotonPrincipal(
                    texto: "Registrarse",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistroUsuario()),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 10,
            child: Text(
              appVersion,
              style: TextStyle(
                fontSize: size.width * 0.035,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageLogo extends StatelessWidget {
  final double width;
  final double height;
  final String image;

  const ImageLogo({
    super.key,
    required this.width,
    required this.height,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class BotonPrincipal extends StatelessWidget {
  final String texto;
  final VoidCallback onTap;

  const BotonPrincipal({
    super.key,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: size.width * 0.7,
        height: size.height * 0.07,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            texto,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
