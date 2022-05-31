import 'dart:io';

import 'package:biometric/application/secure_apps_cubit.dart';
import 'package:biometric/di/injection.dart';
import 'package:biometric/feature/biometric_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<SecureAppsCubit, SecureAppsState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (state is OnSecretKeyReady)
                    ? Text(getIt<SecureAppsCubit>().keyData!)
                    : Text("No Key"),
              ],
            );
          },
        ),
      ),
    );
  }
}
