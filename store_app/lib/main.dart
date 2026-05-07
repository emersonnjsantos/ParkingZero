import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:store_app/firebase_options.dart';
import 'package:store_app/app.dart';
import 'package:store_app/core/di/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0x00000000),
      systemNavigationBarDividerColor: Color(0x00000000),
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Color(0x00000000),
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize(); // Inicialização obrigatória para google_sign_in ^7.0.0
  await di.initDependencies();

  runApp(const StorePartnerApp());
}
