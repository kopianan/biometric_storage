// import 'dart:async';
// import 'package:biometric/di/injection.dart';
// import 'package:biometric/feature/biometric_helper.dart';
// import 'package:biometric/feature/life_cycle_manager.dart';
// import 'package:biometric/feature/local_secure_storage_helper.dart';
// import 'package:biometric/pages/page1.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:secure_application/secure_application.dart';

// import 'application/secure_apps_cubit.dart';
// import 'application/secureapps_controller.dart';

// void main() {
//   setup();
//   runApp(
//     MaterialApp(
//         home: BlocProvider(
//       create: (context) => getIt<SecureAppsCubit>(),
//       child: MyApp(),
//     )),
//   );
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   bool failedAuth = false;
//   double blurr = 20;
//   double opacity = 0.6;
//   StreamSubscription<bool>? subLock;
//   List<String> history = [];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addObserver(this);
//   }

//   @override
//   void dispose() {
//     subLock?.cancel();
//     WidgetsBinding.instance!.removeObserver(this);
//     super.dispose();
//   }

//   final storage = LocalSecureStorageHelper();

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width * 0.8;
//     return LifeCycleManager(
//       child: BlocBuilder<SecureAppsCubit, SecureAppsState>(
//         builder: (context, state) {
//           return MaterialApp(
//               home: SecureApplication(
//             nativeRemoveDelay: 1000,
//             secureApplicationController: (state is SecureAppsInitial)
//                 ? state.secureApplicationController
//                 : null,
//             onNeedUnlock: (secure) async {
//               BiometricHelper biometricHelper = BiometricHelper();
//               var _result = await biometricHelper.authenticate();
//               if (_result) {
//                 secure!.authSuccess(unlock: true);
//                 return SecureApplicationAuthenticationStatus.SUCCESS;
//               } else {
//                 secure!.authFailed(unlock: false);
//                 return SecureApplicationAuthenticationStatus.FAILED;
//               }
//             },
//             onAuthenticationFailed: () async {
//               // clean you data
//               setState(() {
//                 failedAuth = true;
//               });
//               print('auth failed');
//             },
//             onAuthenticationSucceed: () async {
//               // clean you data

//               setState(() {
//                 failedAuth = false;
//               });
//               print('auth success');
//             },
//             autoUnlockNative: true,
//             child: Builder(builder: (context) {
//               if (subLock == null)
//                 subLock = SecureApplicationProvider.of(context, listen: false)
//                     ?.lockEvents
//                     .listen((s) => history.add(
//                         '${DateTime.now().toIso8601String()} - ${s ? 'locked' : 'unlocked'}'));
//               return SecureGate(
//                 blurr: blurr,
//                 opacity: opacity,
//                 lockedBuilder: (context, secureNotifier) {
//                   return Center(
//                       child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       ElevatedButton(
//                         child: Text('UNLOCK'),
//                         onPressed: () =>
//                             secureNotifier?.authSuccess(unlock: true),
//                       ),
//                       ElevatedButton(
//                         child: Text('FAIL AUTHENTICATION'),
//                         onPressed: () =>
//                             secureNotifier?.authFailed(unlock: true),
//                       ),
//                     ],
//                   ));
//                 },
//                 child: Scaffold(
//                   appBar: AppBar(
//                     title: const Text('Secure Window Example'),
//                     actions: [
//                       TextButton(
//                           onPressed: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => Page1()));
//                           },
//                           child: Text("Page 1"))
//                     ],
//                   ),
//                   body: Center(
//                     child: Builder(builder: (context) {
//                       var valueNotifier = SecureApplicationProvider.of(context);
//                       if (valueNotifier == null)
//                         throw new Exception(
//                             'Unable to find secure application context');
//                       return ListView(
//                         children: <Widget>[
//                           Text('This is secure content'),
//                           ValueListenableBuilder<SecureApplicationState>(
//                             valueListenable: valueNotifier,
//                             builder: (context, state, _) => state.secured
//                                 ? Column(
//                                     children: <Widget>[
//                                       ElevatedButton(
//                                         onPressed: () => valueNotifier.open(),
//                                         child: Text('Open app'),
//                                       ),
//                                       state.paused
//                                           ? ElevatedButton(
//                                               onPressed: () =>
//                                                   valueNotifier.unpause(),
//                                               child: Text('resume security'),
//                                             )
//                                           : ElevatedButton(
//                                               onPressed: () =>
//                                                   valueNotifier.pause(),
//                                               child: Text('pause security'),
//                                             ),
//                                     ],
//                                   )
//                                 : ElevatedButton(
//                                     onPressed: () => valueNotifier.secure(),
//                                     child: Text('Secure app'),
//                                   ),
//                           ),
//                           if (failedAuth == null)
//                             Text(
//                                 'Lock the app then switch to another app and come back'),
//                           if (failedAuth != null)
//                             failedAuth
//                                 ? Text(
//                                     'Auth failed we cleaned sensitive data',
//                                     style: TextStyle(color: Colors.red),
//                                   )
//                                 : Text(
//                                     'Auth success',
//                                     style: TextStyle(color: Colors.green),
//                                   ),
//                           FlutterLogo(
//                             size: width,
//                           ),
//                           StreamBuilder(
//                             stream: valueNotifier.authenticationEvents,
//                             builder: (context, snapshot) =>
//                                 Text('Last auth status is: ${snapshot.data}'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () => valueNotifier.lock(),
//                             child: Text('manually lock'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               storage.writeData(
//                                   key: 'key', value: "This is my key");
//                             },
//                             child: Text('Save data to storage'),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: <Widget>[
//                                 Text('Blurr:'),
//                                 Expanded(
//                                   child: Slider(
//                                       value: blurr,
//                                       min: 0,
//                                       max: 100,
//                                       onChanged: (v) =>
//                                           setState(() => blurr = v)),
//                                 ),
//                                 Text(blurr.floor().toString()),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: <Widget>[
//                                 Text('opacity:'),
//                                 Expanded(
//                                   child: Slider(
//                                       value: opacity,
//                                       min: 0,
//                                       max: 1,
//                                       onChanged: (v) =>
//                                           setState(() => opacity = v)),
//                                 ),
//                                 Text((opacity * 100).floor().toString() + "%"),
//                               ],
//                             ),
//                           ),
//                           ...history.map<Widget>((h) => Text(h)).toList(),
//                         ],
//                       );
//                     }),
//                   ),
//                 ),
//               );
//             }),
//           ));
//         },
//       ),
//     );
//   }
// }
