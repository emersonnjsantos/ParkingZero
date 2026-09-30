import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkingzero/app.dart';
import 'package:parkingzero/core/utils/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa o Google Sign-In (obrigatório para google_sign_in ^7.0.0)
  await GoogleSignIn.instance.initialize();

  // Configura o app para preencher toda a tela (edge-to-edge)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0x00000000), // Real transparent
    systemNavigationBarDividerColor: Color(0x00000000),
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Color(0x00000000),
    statusBarIconBrightness: Brightness.dark,
  ));

  // Inicialização de dependências
  await di.initDependencies();

  runApp(const ParkingZeroApp());
}
