// © 2022 Daily, Co. All Rights Reserved

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:daily_flutter/daily_flutter.dart';
import 'package:daily_flutter_demo/app_message.dart';
import 'package:daily_flutter_demo/chat_button.dart';
import 'package:daily_flutter_demo/chat_message.dart';
import 'package:daily_flutter_demo/daily_ui.dart';
import 'package:daily_flutter_demo/device_settings_bar.dart';
import 'package:daily_flutter_demo/local_participant_view.dart';
import 'package:daily_flutter_demo/logging.dart';
import 'package:daily_flutter_demo/participant_list_bottom_sheet.dart';
import 'package:daily_flutter_demo/recording_button.dart';
import 'package:daily_flutter_demo/remote_participant_view.dart';
import 'package:daily_flutter_demo/room_settings_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLogging();
  final client = await CallClient.create();
  runApp(
      MyApp(prefs: await SharedPreferences.getInstance(), callClient: client));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.prefs, required this.callClient});

  final SharedPreferences prefs;
  final CallClient callClient;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final CallClient _callClient;
  late final SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _callClient = widget.callClient;
    _prefs = widget.prefs;
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(prefs: _prefs, callClient: _callClient),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.prefs, required this.callClient});

  final SharedPreferences prefs;
  final CallClient callClient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Flutter Demo')),
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DailyUi(
                    prefs: prefs,
                    callClient: callClient,
                  ),
                ),
              );
            },
            child: const Text('Start Call'),
          ),
        ),
      ),
    );
  }
}
