import 'package:flutter/material.dart';

class PINScreen extends StatelessWidget {
  PINScreen(
      {required this.onOpenBiometrics,
      required this.onUnlockFailed,
      required this.onUnlockWithoutReadKey,
      required this.onUnlockSuccess});
  final VoidCallback onUnlockFailed;
  final VoidCallback onUnlockSuccess;
  final VoidCallback onUnlockWithoutReadKey;
  final VoidCallback onOpenBiometrics;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlutterLogo(size: 120),
          SizedBox(height: 30),
          ElevatedButton(
            child: Text('Unlock Without Load Key'),
            onPressed: () {
              onUnlockWithoutReadKey();
            },
          ),
          Text('''
Unlock without load : Unlock akan success dan langsung masuk ke homepage
Button ini untuk test jika terjadi hacking dan langsung bypass ke HomePage'''),
          SizedBox(height: 30),
          ElevatedButton(
            child: Text('Unlock With Load Key'),
            onPressed: () {
              onUnlockSuccess();
            },
          ),
          Text('''
Unlock Success, setelah itu langsung load dari keychain
'''),
          SizedBox(height: 30),
          ElevatedButton(
            child: Text('Unlock And Failed'),
            onPressed: () {
              onUnlockFailed();
            },
          ),
          Text('''
Unlock Failed
'''),
          SizedBox(height: 30),
          ElevatedButton(
            child: Text('Open Biometrics'),
            onPressed: () {
              onOpenBiometrics();
            },
          ),
             Text(
              '''
Unlock With biometrics and load data if success
'''),
        ],
      ),
    );
  }
}
