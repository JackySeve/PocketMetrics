import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificacionesMotivacionalesScreen extends StatefulWidget {
  const NotificacionesMotivacionalesScreen({super.key});

  @override
  State<NotificacionesMotivacionalesScreen> createState() =>
      _NotificacionesMotivacionalesScreenState();
}

class _NotificacionesMotivacionalesScreenState
    extends State<NotificacionesMotivacionalesScreen> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<String> _frases = [];
  bool _notificacionesActivas = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadFrases();
    _loadPreferencias();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings);
  }

  Future<void> _loadFrases() async {
    final jsonStr =
        await rootBundle.loadString('lib/assets/data/frases_recordatorios.json');
    final jsonData = jsonDecode(jsonStr);
    setState(() {
      _frases = List<String>.from(jsonData['ahorro']);
    });
  }

  Future<void> _loadPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    final activado = prefs.getBool('notificaciones_motivacionales') ?? false;
    setState(() {
      _notificacionesActivas = activado;
    });

    if (activado) {
      _programarNotificacionDiaria();
    }
  }

  Future<void> _guardarPreferencias(bool activado) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificaciones_motivacionales', activado);
  }

  Future<void> _programarNotificacionDiaria() async {
    if (_frases.isEmpty) return;

    final frase = _frases[Random().nextInt(_frases.length)];
    final ahora = DateTime.now();
    final horaProgramada = DateTime(ahora.year, ahora.month, ahora.day, 9, 0);
    final tzFecha = tz.TZDateTime.from(horaProgramada.isBefore(ahora)
        ? horaProgramada.add(Duration(days: 1))
        : horaProgramada, tz.local);

    final detalles = AndroidNotificationDetails(
      'motivacional_channel',
      'Notificaciones Motivacionales',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _notificationsPlugin.zonedSchedule(
      9999,
      'Frase motivacional del día',
      frase,
      tzFecha,
      NotificationDetails(android: detalles),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _cancelarNotificaciones() async {
    await _notificationsPlugin.cancel(9999);
  }

  void _toggleNotificaciones(bool activado) async {
    setState(() {
      _notificacionesActivas = activado;
    });
    await _guardarPreferencias(activado);
    if (activado) {
      _programarNotificacionDiaria();
    } else {
      _cancelarNotificaciones();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motivación de Ahorro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Recibir notificaciones motivacionales diarias'),
              value: _notificacionesActivas,
              onChanged: _toggleNotificaciones,
            ),
            const SizedBox(height: 20),
            const Text(
              'Frases motivacionales:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _frases.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.format_quote),
                  title: Text(_frases[index]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
