import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BiometricLoginPage(),
    );
  }
}

class BiometricLoginPage extends StatefulWidget {
  @override
  State<BiometricLoginPage> createState() => _BiometricLoginPageState();
}

class _BiometricLoginPageState extends State<BiometricLoginPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  String _biometricType = '';
  String message = '';

  Future<void> checkBiometrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;

    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics = await _localAuthentication.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.face)) {
        _biometricType = 'Face ID';
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        _biometricType = 'Fingerprint';
      }
      if (mounted) {
        _authenticate();
      }
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to access the app',
      );
    } catch (e) {
      print('Error: $e');
    }

    if (authenticated) {
      setState(() {
        message = 'You have successfully logged in.';
      });

      // Biometric authentication successful, navigate to the main screen
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => MainScreen()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biometric Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$message'),
            ElevatedButton(
              onPressed: () {
                checkBiometrics();
              },
              child: Text('Authenticate with $_biometricType'),
            ),
          ],
        ),
      ),
    );
  }
}
