import 'package:biometric/features/biometric/data/repositories/b_auth_repository_impl.dart';
import 'package:biometric/features/biometric/domain/repositories/b_auth_repository.dart';
import 'package:biometric/features/biometric/domain/usecases/authenticate_with_biometric.dart';
import 'package:biometric/features/biometric/presentation/bloc/biometric_bloc.dart';
import 'package:biometric/features/global/util/biometric_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestHome extends StatefulWidget {
  const TestHome({Key? key}) : super(key: key);

  @override
  State<TestHome> createState() => _TestHomeState();
}

class _TestHomeState extends State<TestHome> {
  BiometricHelper _biometricHelper = BiometricHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => BiometricBloc(
            AuthenticateWithBiometric(BAuthRepositoryImpl(_biometricHelper))),
        child: BlocConsumer<BiometricBloc, BiometricState>(
          listener: (context, state) {
            print(state); 
          },
          builder: (context, state) {
            return Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {},
                    child: Text("Has biometric"),
                  ),
                  ElevatedButton(
                    onPressed: () async {},
                    child: Text("Can Use biometric"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      context.read<BiometricBloc>().add(Authenticate()); 
                      // try {
                      //   var _hasBiometric = await helper.authenticate();
                      //   print(_hasBiometric);
                      // } catch (e) {
                      //   showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return AlertDialog(
                      //           content: Text(e.toString()),
                      //         );
                      //       });
                      // }
                    },
                    child: Text("Authentic biometric"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
