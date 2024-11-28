import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login.dart';
import 'reservasi.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('users');
  await Hive.openBox('session');

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
    // Navigasi ke halaman utama
    if (response.payload == 'mainpage') {
      runApp(MyApp(goToMainPage: true));
    } else {
      runApp(MyApp());
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool goToMainPage;

  MyApp({this.goToMainPage = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: goToMainPage ? MainPage() : LoginPage(),
    );
  }
}
