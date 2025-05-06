// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecordatoriosScreen extends StatefulWidget {
  const RecordatoriosScreen({super.key});

  @override
  _RecordatoriosScreenState createState() => _RecordatoriosScreenState();
}

class _RecordatoriosScreenState extends State<RecordatoriosScreen> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _recordatorios = [];
  late String _userId;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadRecordatorios();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> _scheduleNotification(String message, DateTime dateTime) async {
    final scheduledDate = DateTime(dateTime.year, dateTime.month, dateTime.day, 8, 0);
    final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

    final androidDetails = AndroidNotificationDetails(
      'recordatorio_channel',
      'Recordatorios',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      scheduledDate.millisecondsSinceEpoch ~/ 1000,
      'Recordatorio del día',
      message,
      tzDateTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> _addOrEditRecordatorio({int? index}) async {
    if (_controller.text.isEmpty || _selectedDate == null) return;

    final nuevo = {
      'mensaje': _controller.text,
      'fecha': _selectedDate!.toIso8601String(),
    };

    if (index != null) {
      _recordatorios[index] = nuevo;
    } else {
      _recordatorios.add(nuevo);
    }

    await _scheduleNotification(nuevo['mensaje']!, _selectedDate!);
    await _saveRecordatorios();
    await _syncWithFirestore();

    setState(() {
      _controller.clear();
      _selectedDate = null;
    });
  }

  Future<void> _saveRecordatorios() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_recordatorios);
    await prefs.setString('recordatorios_$_userId', encoded);
  }

  Future<void> _loadRecordatorios() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _userId = user.uid;

    final data = prefs.getString('recordatorios_$_userId');

    if (data != null) {
      final decoded = jsonDecode(data);
      _recordatorios = (decoded as List)
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();

      for (var r in _recordatorios) {
        final fecha = DateTime.parse(r['fecha']);
        if (fecha.isAfter(DateTime.now())) {
          await _scheduleNotification(r['mensaje'], fecha);
        }
      }

      setState(() {});
    }
  }

  Future<void> _syncWithFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    await firestore.collection('usuarios').doc(user.uid).set({
      'recordatorios': _recordatorios,
    });
  }

  Future<void> _deleteRecordatorio(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar recordatorio?'),
        content: const Text('¿Estás seguro de que deseas eliminar este recordatorio?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _recordatorios.removeAt(index);
      });

      await _saveRecordatorios();
      await _syncWithFirestore();
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _startEditRecordatorio(int index) {
    final r = _recordatorios[index];
    _controller.text = r['mensaje'];
    _selectedDate = DateTime.parse(r['fecha']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar recordatorio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Mensaje'),
            ),
            ElevatedButton(
              onPressed: _pickDate,
              child: Text(_selectedDate == null
                  ? 'Seleccionar fecha'
                  : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await _addOrEditRecordatorio(index: index);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recordatorios')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Escribe un recordatorio'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickDate,
              child: Text(_selectedDate == null
                  ? 'Seleccionar fecha'
                  : 'Fecha: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _addOrEditRecordatorio(),
              child: const Text('Guardar y programar notificación'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _recordatorios.length,
                itemBuilder: (context, index) {
                  final r = _recordatorios[index];
                  return ListTile(
                    leading: const Icon(Icons.notifications_active),
                    title: Text(r['mensaje']),
                    subtitle: Text(DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(r['fecha']))),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _startEditRecordatorio(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteRecordatorio(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
