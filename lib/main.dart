import 'dart:async';
import 'package:biometric/di/injection.dart';
import 'package:biometric/feature/biometric_helper.dart';
import 'package:biometric/feature/life_cycle_manager.dart';
import 'package:biometric/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_application/secure_application.dart';
import 'application/secure_apps_cubit.dart';
import 'features/biometric/presentation/pages/test_home.dart';
import 'pages/pin_screen_page.dart';

void main() {
  setup();
  runApp(BlocProvider(
    create: (context) => getIt<SecureAppsCubit>(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool failedAuth = false;
  double blurr = 20;
  double opacity = 0.6;
  final _bio = BiometricHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    secureApplicationController!.secure();
    secureApplicationController!.lock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  bool isLocked = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // remove key from bloc
        getIt<SecureAppsCubit>().removeKey();
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }

  SecureApplicationController? secureApplicationController =
      SecureApplicationController(SecureApplicationState());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TestHome());
  }
}
