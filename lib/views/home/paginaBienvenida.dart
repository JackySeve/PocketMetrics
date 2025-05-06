// ignore_for_file: library_private_types_in_public_api, file_names

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
      appVersion = "Versión: ${packageInfo.version}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/welcome_background.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withAlpha((0.15 * 255).toInt()),
                  BlendMode.lighten,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.12),
                  ImageLogo(
                    width: size.width * 0.5,
                    height: size.height * 0.22,
                    image: 'lib/assets/images/logo.png',
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    "PocketMetrics",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: size.width * 0.09,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Asap',
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),
                  Text(
                    '¡Hola! Qué alegría tenerte aquí 🌟',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Asap',
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.045,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
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
                  SizedBox(height: size.height * 0.02),
                  Text(
                    "¿Nuevo por aquí? Únete y comienza tu viaje hacia unas finanzas sanas 💰",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Asap',
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.045,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
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
                  SizedBox(height: size.height * 0.06),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              appVersion,
              style: TextStyle(
                fontSize: size.width * 0.035,
                color: Colors.black45,
                fontWeight: FontWeight.w600,
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
        width: size.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withAlpha((0.45 * 255).toInt()),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            texto,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.048,
              fontWeight: FontWeight.bold,
              fontFamily: 'Asap',
            ),
          ),
        ),
      ),
    );
  }
}
